// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "pro_video_editor",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "pro-video-editor", targets: ["pro_video_editor"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "pro_video_editor",
            dependencies: [],
            path: ".",
            sources: ["Classes"],
            resources: [
                .process("Resources/PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
