PageController
==================
[![Build-Status](https://api.travis-ci.org/hirohisa/PageController.svg?branch=master)](https://travis-ci.org/hirohisa/PageController)
[![CocoaPods](https://img.shields.io/cocoapods/v/PageController.svg)](https://cocoapods.org/pods/PageController)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![license](https://img.shields.io/badge/license-MIT-000000.svg)](https://github.com/hirohisa/ImageLoaderSwift/blob/master/LICENSE)

PageController is infinite paging controller, scrolling through contents and title bar scrolls with a delay. Then it provide user interaction to smoothly and effortlessly moving. It is for iOS written in Swift.

![sample](Example%20project/example.gif)

Requirements
----------
- iOS 8.0+
- Xcode 7.0+

PageController | Xcode | Swift
-------------- | ----- | -----
0.7.x          | 9.4   | 4.1
0.6.x          | 9.2   | 4.0
0.5.x          | 8.2   | 3.0
0.4.x          | 8.0   | 2.2
0.3.x          | 7.0+  | 2.0
0.2.0          | 6.4   | 1.2


Features
----------

- [x] To inherit from [DCScrollView](https://github.com/hirohisa/DCScrollView)
- [x] Use `UIViewController`, not `UIView` like `UITabBarController`
- [x] Support AutoLayout about MenuCell
- [x] Handling to change current view controller with Delegate.
- [x] Scrolling smoothly and effortlessly
- [ ] Keep to smoothly in scrolling contents too much

Installation
----------

### CocoaPods

```ruby
pod 'PageController'
```

### Carthage

To integrate PageController into your Xcode project using Carthage, specify it in your `Cartfile`:

```
github "hirohisa/PageController" ~> 0.6.0
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

Enable to change backgroundColor, frame.
If you change MenuBarCell.height, then override `frameForMenuBar` and set height.
```swift
// backgroudColor
menuBar.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)

// frame, override this function
override var frameForMenuBar: CGRect {
    let frame = super.frameForMenuBar

    return CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: 60)
}
```

**MenuBarCell**

Enable to use Custom Cell supported `MenuBarCellable` protocol:
```swift
public protocol MenuBarCellable {
    var index: Int { get set }
    func setTitle(_ title: String)
    func setHighlighted(_ highlighted: Bool)
    func prepareForReuse()
}

public func register(_ cellClass: MenuBarCellable) {
    guard let cellClass = cellClass as? UIView.Type else { fatalError() }
    self.cellClass = cellClass
}

public func register(_ nib: UINib) {
    self.nib = nib
}
```

**MenuBarCellable**

```
public protocol MenuBarCellable {
    
    // it's used by PageController
    var index: Int { get set }
    
    // it is used to set to Label.text, caused by deprecating MenuCell over 0.7
    func setTitle(_ title: String)
    
    // it's instead of `updateData` over 0.7, 
    func setHighlighted(_ highlighted: Bool)
    
    // Called by the menu bar on creating the instance.
    func prepareForUse()

}
```

## License

PageController is available under the MIT license.
