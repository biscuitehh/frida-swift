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
            url: "https://github.com/biscuitehh/frida-swift/releases/download/12.11.6/CFrida.xcframework.zip",
            checksum: "663e2d0003add894a450bc3546184a0ee9b6ae51d6d02bfd3534a75d17290bce"
        )
    ]
)
