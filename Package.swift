// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Kitura-Session-GRDB",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "KituraSessionGRDB",
            targets: ["KituraSessionGRDB"]),
    ],
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura-Session.git", from: "3.3.4"),
        .package(name: "GRDB", url: "https://github.com/groue/GRDB.swift.git", from: "4.14.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "KituraSessionGRDB",
            dependencies: [
                .product(name: "KituraSession", package: "Kitura-Session"),
                "GRDB"]),
        .testTarget(
            name: "KituraSessionGRDBTests",
            dependencies: ["KituraSessionGRDB"]),
    ]
)
