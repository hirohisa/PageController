PageController
==================
[![Build-Status](https://api.travis-ci.org/hirohisa/PageController.svg?branch=master)](https://travis-ci.org/hirohisa/PageController)
[![GitHub-version](https://img.shields.io/github/tag/hirohisa/PageController.svg)](https://github.com/hirohisa/PageController/tags)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![license](https://img.shields.io/badge/license-MIT-000000.svg)](https://github.com/hirohisa/ImageLoaderSwift/blob/master/LICENSE)

PageController is infinite paging controller, scrolling through contents and title bar scrolls with a delay. Then it provide user interaction to smoothly and effortlessly moving. It is for iOS written in Swift.

![sample](Example project/example.gif)

Requirements
----------
- iOS 8.0+
- Xcode 7.0+

PageController | Xcode | Swift
----------- | ----- | -----
0.2.0 | 6.4 | 1.2
0.3+ | 7.0+ | 2.0

Features
----------

- [x] To inherit from [DCScrollView](https://github.com/hirohisa/DCScrollView)
- [x] Use `UIViewController`, not `UIView` like `UITabBarController`
- [x] Scrolling smoothly and effortlessly
- [x] Support AutoLayout about MenuCell
- [x] Handling to change current view controller with Delegate.

Installation
----------

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

To integrate PageController into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'PageController'
```

Then, run the following command:

```bash
$ pod install
```

Usage
----------

**viewControllers**

Type is [UIViewController], and element must have title.

```swift

import PageController

class CustomViewController: PageController {

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = createViewControllers()
    }

    func createViewControllers() -> [UIViewController] {
        let names = [
            "favorites",
            "recents",
            "contacts",
            "history",
            "more",
        ]

        return names.map { name -> UIViewController in
            let viewController = ContentViewController()
            viewController.title = name
            return viewController
        }
    }
}

```

**MenuBar**

Enable to change backgroundColor, frame and MenuCell.

```swift
menuBar.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)
menuBar.registerClass(CustomMenuCell.self)
```

**MenuCell**

- constentInset

Margins between cells are zero, because it is difficult that calculating distance of scrolling.
If you change margins between cell's labels or vertical position, use constentInset.

- updateData()

If property cell's selected is changed, `updateData()` is called. You customize animations of activate to dis-activate, or dis-activate to activate, implement as override `updateData()`.


## License

PageController is available under the MIT license.
