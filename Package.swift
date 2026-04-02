// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SUIRouting",
    platforms: [
           .iOS(.v15),
       ],
    products: [
        .library(
            name: "SUIRouting",
            targets: ["SUIRouting"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/lm/navigation-stack-backport.git", .upToNextMajor(from: "1.1.0"))
    ],
    targets: [
        .target(
            name: "SUIRouting",
            dependencies: [
                .product(name: "NavigationStackBackport", package: "navigation-stack-backport")
            ]
        ),
    ]
)
