//
//  PageController.swift
//  PageController
//
//  Created by Hirohisa Kawasaki on 6/24/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

public protocol PageControllerDelegate: class {
    func pageController(_ pageController: PageController, didChangeVisibleController visibleViewController: UIViewController, fromViewController: UIViewController?)
}

open class PageController: UIViewController {

    open weak var delegate: PageControllerDelegate?

    public var menuBar: MenuBar = MenuBar(frame: CGRect.zero)
    public var visibleViewController: UIViewController? {
        didSet {
            if let visibleViewController = visibleViewController {
                viewDidScroll()
                delegate?.pageController(self, didChangeVisibleController: visibleViewController, fromViewController: oldValue)
            }
        }
    }
    public var viewControllers: [UIViewController] = [] {
        didSet {
            menuBar.items = viewControllers.map { $0.title ?? "" }
        }
    }
    let containerView = ContainerView(frame: CGRect.zero)

    open override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    /// the top from adjusted content inset with menu bar frame
    public var adjustedContentInsetTop: CGFloat {
        if #available(iOS 11.0, *) {
            return menuBar.frame.height
        }
        return menuBar.frame.height + (navigationController?.navigationBar.frame.height ?? 0) + UIApplication.shared.statusBarFrame.height
    }

    /// set frame to MenuBar.frame on viewDidLoad
    open var frameForMenuBar: CGRect {
        var frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44)
        if let frameForNavigationBar = navigationController?.navigationBar.frame {
            frame.origin.y = frameForNavigationBar.maxY
        }

        return frame
    }

    /// set frame to containerView.frame on viewDidLoad
    open var frameForScrollView: CGRect {
        return CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    }

    var frameForLeftContentController: CGRect {
        var frame = frameForScrollView
        frame.origin.x = 0
        return frame
    }

    var frameForCenterContentController: CGRect {
        var frame = frameForScrollView
        frame.origin.x = frame.width
        return frame
    }

    var frameForRightContentController: CGRect {
        var frame = frameForScrollView
        frame.origin.x = frame.width * 2
        return frame
    }

    func configure() {
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            containerView.contentInsetAdjustmentBehavior = .never
        }
        containerView.frame = view.bounds
        containerView.contentSize = CGSize(width: containerView.frame.width * 3, height: containerView.frame.height)
        view.addSubview(containerView)
        menuBar.frame = frameForMenuBar
        view.addSubview(menuBar)
        containerView.controller = self
        menuBar.controller = self
        reloadPages(at: 0)
        containerView.contentOffset = frameForCenterContentController.origin
    }

    public func reloadPages(at index: Int) {
//        print("Function: \(#function), line: \(#line), index: \(index) ")
        for viewController in children {
            if viewController != viewControllers[index] {
                hideViewController(viewController)
            }
        }

        loadPages(at: index)
    }

    public func switchPage(AtIndex index: Int) {
        if containerView.isDragging {
            return
        }

        guard let viewController = viewControllerForCurrentPage() else { return }

        let currentIndex = NSArray(array: viewControllers).index(of: viewController)

        if currentIndex != index {
            reloadPages(at: index)
        }
    }

    func loadPages() {
        if let viewController = viewControllerForCurrentPage() {
            let index = NSArray(array: viewControllers).index(of: viewController)
            loadPages(at: index)
        }
    }

    func loadPages(at index: Int) {
//        print("Function: \(#function), index: \(index)")
        if index >= viewControllers.count { return }
        let visibleViewController = viewControllers[index]
        switchVisibleViewController(visibleViewController)

        // offsetX < 0 or offsetX > contentSize.width
        let frameOfContentSize = CGRect(x: 0, y: 0, width: containerView.contentSize.width, height: containerView.contentSize.height)
        for viewController in children {
            if viewController != visibleViewController && !viewController.view.include(frameOfContentSize) {
                hideViewController(viewController)
            }
        }

        // center
        displayViewController(visibleViewController, frame: frameForCenterContentController)

        // left
        var exists = children.filter { $0.view.include(frameForLeftContentController) }
        if exists.isEmpty {
            displayViewController(viewControllers[(index - 1).relative(viewControllers.count)], frame: frameForLeftContentController)
        }

        // right
        exists = children.filter { $0.view.include(frameForRightContentController) }
        if exists.isEmpty {
            displayViewController(viewControllers[(index + 1).relative(viewControllers.count)], frame: frameForRightContentController)
        }
    }

    func switchVisibleViewController(_ viewController: UIViewController) {
        if visibleViewController != viewController {
            visibleViewController = viewController
        }
    }

    typealias Page = (from: Int, to: Int)
    func getPage() -> Page? {
        guard let visibleViewController = visibleViewController, let viewController = viewControllerForCurrentPage() else { return nil }
        let from = NSArray(array: viewControllers).index(of: visibleViewController)
        let to = NSArray(array: viewControllers).index(of: viewController)

        return Page(from: from, to: to)
    }

    func viewDidScroll() {
        guard let page = getPage() else { return }

        if page.from != page.to {
            move(page: page)
            return
        }
        if !containerView.isTracking || !containerView.isDragging {
            return
        }
        if page.from == page.to {
            revert(page: page)
        }
    }

    func viewDidEndDecelerating() {
        guard let page = getPage(), !containerView.isDragging else { return }
        revert(page: page)
    }

    func revert(page: Page) {
        menuBar.revert(to: page.to)
    }

    func move(page: Page) {
        let width = containerView.frame.width
        if containerView.contentOffset.x > width * 1.5 {
            menuBar.move(from: page.from, until: page.to)
        } else if containerView.contentOffset.x < width * 0.5 {
            menuBar.move(from: page.from, until: page.to)
        }
    }

    func displayViewController(_ viewController: UIViewController, frame: CGRect) {
        guard !children.contains(viewController), !viewController.view.isDescendant(of: containerView) else {
            // already added
            viewController.view.frame = frame
            return
        }
        viewController.willMove(toParent: self)
        addChild(viewController)
        viewController.view.frame = frame
        containerView.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }

    func hideViewController(_ viewController: UIViewController) {
        guard children.contains(viewController), viewController.view.isDescendant(of: containerView) else { return }
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
        viewController.didMove(toParent: nil)
    }

}

extension PageController: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewDidScroll()
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewDidEndDecelerating()
    }

}
