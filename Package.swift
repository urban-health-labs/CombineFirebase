// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CombineFirebase",
    platforms: [.iOS(.v13), .macOS(.v10_15), .tvOS(.v13)],
    products: [
        .library(
            name: "CombineFirebase",
            targets: ["CombineFirebase"]
        ),
        .library(
            name: "CombineFirebaseAuth",
            targets: ["CombineFirebaseAuth"]
        ),
        .library(
            name: "CombineFirebaseDatabase",
            targets: ["CombineFirebaseDatabase"]
        ),
        .library(
            name: "CombineFirebaseFirestore",
            targets: ["CombineFirebaseFirestore"]
        ),
        .library(
            name: "CombineFirebaseFunctions",
            targets: ["CombineFirebaseFunctions"]
        ),
        .library(
            name: "CombineFirebaseRemoteConfig",
            targets: ["CombineFirebaseRemoteConfig"]
        ),
        .library(
            name: "CombineFirebaseStorage",
            targets: ["CombineFirebaseStorage"]
        ),
    ],
    dependencies: [
        .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk.git", "7.3.1"..<"12.0.0"),
    ],
    targets: [
        .target(
            name: "CombineFirebase",
            dependencies: [
                "CombineFirebaseAuth",
                "CombineFirebaseDatabase",
                "CombineFirebaseFirestore",
                "CombineFirebaseFunctions",
                "CombineFirebaseRemoteConfig",
                "CombineFirebaseStorage",
            ],
            path: "Sources/Core"
        ),
        .target(
            name: "CombineFirebaseAuth",
            dependencies: [
                .product(name: "FirebaseAuth", package: "Firebase"),
            ],
            path: "Sources/Auth"
        ),
        .target(
            name: "CombineFirebaseDatabase",
            dependencies: [
                .product(name: "FirebaseDatabase", package: "Firebase"),
            ],
            path: "Sources/Database"
        ),
        .target(
            name: "CombineFirebaseFirestore",
            dependencies: [
                .product(name: "FirebaseFirestore", package: "Firebase"),
            ],
            path: "Sources/Firestore"
        ),
        .target(
            name: "CombineFirebaseFunctions",
            dependencies: [
                .product(name: "FirebaseFunctions", package: "Firebase"),
            ],
            path: "Sources/Functions"
        ),
        .target(
            name: "CombineFirebaseRemoteConfig",
            dependencies: [
                .product(name: "FirebaseRemoteConfig", package: "Firebase"),
            ],
            path: "Sources/RemoteConfig"
        ),
        .target(
            name: "CombineFirebaseStorage",
            dependencies: [
                .product(name: "FirebaseStorage", package: "Firebase"),
            ],
            path: "Sources/Storage"
        )
    ]
)

