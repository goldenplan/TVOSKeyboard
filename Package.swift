// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TVOSKeyboard",
        platforms: [.tvOS(.v13)],
    products: [
        .library(
            name: "TVOSKeyboard",
            targets: ["TVOSKeyboard"]),
        .library(
            name: "Cartography",
            targets: ["Cartography"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "TVOSKeyboard",
            dependencies: ["Cartography"]),
        .target(
            name: "Cartography",
            dependencies: []),
        .testTarget(
            name: "TVOSKeyboardTests",
            dependencies: ["TVOSKeyboard"]),
    ]
)
