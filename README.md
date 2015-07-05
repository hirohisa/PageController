PageController
==================

PageController is infinite pages controller, scrolling through contents and title bar scrolls with a delay. Then it provide user interaction to smoothly and effortlessly moving. It is for iOS written in Swift.

![sample](Example/example.gif)

Requirements
----------
- iOS 8.0+

Features
----------

- [x] To inherit from DCScrollView
- [x] Use `UIViewController`, not `UIView` like `UITabBarController`
- [x] Scrolling smoothly and effortlessly
- [x] Support AutoLayout about MenuCell
- [ ] Handling to change current view controller with Delegate.

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
        var viewControllers = [UIViewController]()

        let names = [
            "Home",
            "Innovation",
            "Technology",
            "Life",
        ]

        for name in names {
            let viewController = ItemsCollectionViewController()
            viewController.title = name
            viewControllers.append(viewController)
        }
    }
}

```

## License

PageController is available under the MIT license.
