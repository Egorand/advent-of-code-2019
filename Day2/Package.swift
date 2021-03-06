// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Day2",
    dependencies: [
        .package(path: "../Utils"),
        .package(path: "../Intcode"),
    ],
    targets: [
        .target(
            name: "Day2",
            dependencies: ["Utils", "Intcode"]),
    ]
)
