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

    open var menuBar: MenuBar = MenuBar(frame: CGRect.zero)
    open var visibleViewController: UIViewController? {
        didSet {
            if let visibleViewController = visibleViewController {
                delegate?.pageController(self, didChangeVisibleController: visibleViewController, fromViewController: oldValue)
            }
        }
    }
    open var viewControllers: [UIViewController] = [] {
        didSet {
            reload()
        }
    }
    open var scrollView: UIScrollView {
        return containerView
    }

    let containerView = ContainerView(frame: CGRect.zero)

    open override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false

        configure()
    }

    // set frame to MenuBar.frame on viewDidLoad
    open var frameForMenuBar: CGRect {
        var frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44)
        if let frameForNavigationBar = navigationController?.navigationBar.frame {
            frame.origin.y = frameForNavigationBar.maxY
        }

        return frame
    }

    // set frame to containerView.frame on viewDidLoad
    open var frameForScrollView: CGRect {
        return view.bounds
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
        let frame = frameForScrollView
        containerView.frame = frame
        containerView.controller = self

        containerView.contentSize = CGSize(width: frame.width * 3, height: frame.height)
        view.addSubview(containerView)

        menuBar.frame = frameForMenuBar
        menuBar.controller = self
        view.addSubview(menuBar)
    }

    func reload() {
        if !isViewLoaded {
            return
        }

//        print("Function: \(#function), line: \(#line)")
        menuBar.items = viewControllers.map { $0.title ?? "" }
    }

    public func reloadPages(at index: Int) {
//        print("Function: \(#function), line: \(#line), index: \(index) ")
        for viewController in childViewControllers {
            if viewController != viewControllers[index] {
                hideViewController(viewController)
            }
        }

        containerView.contentOffset = frameForCenterContentController.origin
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
//        print("Function: \(#function), line: \(#line)")
        if index >= viewControllers.count { return }
        let visibleViewController = viewControllers[index]
        switchVisibleViewController(visibleViewController)

        // offsetX < 0 or offsetX > contentSize.width
        let frameOfContentSize = CGRect(x: 0, y: 0, width: containerView.contentSize.width, height: containerView.contentSize.height)
        for viewController in childViewControllers {
            if viewController != visibleViewController && !viewController.view.include(frameOfContentSize) {
                hideViewController(viewController)
            }
        }

        // center
        displayViewController(visibleViewController, frame: frameForCenterContentController)

        // left
        var exists = childViewControllers.filter { $0.view.include(frameForLeftContentController) }
        if exists.isEmpty {
            displayViewController(viewControllers[(index - 1).relative(viewControllers.count)], frame: frameForLeftContentController)
        }

        // right
        exists = childViewControllers.filter { $0.view.include(frameForRightContentController) }
        if exists.isEmpty {
            displayViewController(viewControllers[(index + 1).relative(viewControllers.count)], frame: frameForRightContentController)
        }
    }

    func switchVisibleViewController(_ viewController: UIViewController) {
        if visibleViewController != viewController {
            visibleViewController = viewController
        }
    }
}

extension PageController: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewDidScroll()
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewDidScroll()
    }

}

extension PageController {

    func viewDidScroll() {
        guard let visibleViewController = visibleViewController else { return }

        if let viewController = viewControllerForCurrentPage() {

            let from = NSArray(array: viewControllers).index(of: visibleViewController)
            let to = NSArray(array: viewControllers).index(of: viewController)

            if viewController != visibleViewController {
                move(from, to: to)
                return
            }

            if !containerView.isTracking || !containerView.isDragging {
                return
            }
            if from == to {
                revert(to)
            }
        }
    }

    func move(_ from: Int, to: Int) {

        let width = containerView.frame.width
        if containerView.contentOffset.x > width * 1.5 {
            menuBar.move(from: from, until: to)
        } else if containerView.contentOffset.x < width * 0.5 {
            menuBar.move(from: from, until: to)
        }
    }

    func revert(_ to: Int) {
        menuBar.revert(to)
    }

    func displayViewController(_ viewController: UIViewController, frame: CGRect) {
        addChildViewController(viewController)
        viewController.view.frame = frame
        containerView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }

    func hideViewController(_ viewController: UIViewController) {
        viewController.willMove(toParentViewController: self)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }

}
