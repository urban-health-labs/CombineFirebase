// swift-tools-version:5.2
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
    ],
    dependencies: [
        .package(
            name: "Firebase",
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            .branch("6.31-spm-beta")
        ),
    ],
    targets: [
        .target(
            name: "CombineFirebase",
            dependencies: [
                .product(name: "Firebase", package: "Firebase"),
                .product(name: "FirebaseCore", package: "Firebase"),
                .product(name: "FirebaseAuth", package: "Firebase"),
                .product(name: "FirebaseDatabase", package: "Firebase"),
                .product(name: "FirebaseFirestore", package: "Firebase"),
                .product(name: "FirebaseFirestoreSwift", package: "Firebase"),
                .product(name: "FirebaseFunctions", package: "Firebase"),
                .product(name: "FirebaseRemoteConfig", package: "Firebase"),
                .product(name: "FirebaseStorage", package: "Firebase"),
            ],
            path: "Sources"
        )
    ]
)

