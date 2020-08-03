// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Frida",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "Frida",
            type: .dynamic,
            targets: ["Frida"]
        )
    ],
    targets: [
        .target(
            name: "Frida",
            dependencies: ["CFrida"],
            linkerSettings: [
                .linkedLibrary("resolv"),
                .linkedLibrary("bsm")
            ]
        ),
        .binaryTarget(
            name: "CFrida",
            path: "artifacts/CFrida.xcframework"
        )
    ]
)
