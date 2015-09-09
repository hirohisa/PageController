//
//  PageController+ContainerView.swift
//  PageController
//
//  Created by Hirohisa Kawasaki on 6/26/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

extension PageController {

    class ContainerView: UIScrollView {

        weak var controller: PageController? {
            didSet {
                delegate = controller
            }
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            configure()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            configure()
        }

        func configure() {
            directionalLockEnabled = true
            showsHorizontalScrollIndicator = false
            showsVerticalScrollIndicator = false
            scrollsToTop = false
            pagingEnabled = true
        }

        override func layoutSubviews() {
            super.layoutSubviews()

            if frame.size == CGSizeZero {
                return
            }

            if needsRecenter() {
                cancelTouches()
                recenter(relativeView: self)
                controller?.loadPages()
            }
        }

        func cancelTouches() {
            panGestureRecognizer.enabled = false
            panGestureRecognizer.enabled = true
        }
    }
}