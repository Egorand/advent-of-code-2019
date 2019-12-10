// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Day3",
    dependencies: [
      .package(path: "../Utils"),
    ],
    targets: [
        .target(
            name: "Day3",
            dependencies: ["Utils"]),
    ]
)
