// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "PageController",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "PageController",
            targets: ["PageController"]),
    ],
    targets: [
        .target(
            name: "PageController",
            dependencies: [
            ],
            path: "./PageController",
            exclude: [
                "Info.plist",
                "PageController.h"
            ]
        )
    ]
    )
