//
//  PageController+ContainerView.swift
//  PageController
//
//  Created by Hirohisa Kawasaki on 6/26/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit

extension PageController {

    class ContainerView: ScrollView {

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
            isDirectionalLockEnabled = true
            showsHorizontalScrollIndicator = false
            showsVerticalScrollIndicator = false
            scrollsToTop = false
            isPagingEnabled = true
        }

        override func layoutSubviews() {
            super.layoutSubviews()

            if frame.size == CGSize.zero {
                return
            }

            if needsRecenter() {
                recenter(relativeView: self)
                controller?.loadPages()
            }
        }
    }
}
