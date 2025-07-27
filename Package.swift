// swift-tools-version:5.9

import Foundation
import PackageDescription

extension String {
    static let multipartURLFormCoding: Self = "URLMultipartFormCoding"
    static let multipartURLFormCodingURLRouting: Self = "URLMultipartFormCodingURLRouting"
    static let urlFormCodingURLRouting: Self = "URLFormCodingURLRouting"
}

extension Target.Dependency {
    static var urlFormCodingURLRouting: Self { .target(name: .urlFormCodingURLRouting) }
}

extension Target.Dependency {
    static var dependencies: Self { .product(name: "Dependencies", package: "swift-dependencies") }
    static var dependenciesTestSupport: Self { .product(name: "DependenciesTestSupport", package: "swift-dependencies") }
    static var parsing: Self { .product(name: "Parsing", package: "swift-parsing") }
    static var urlRouting: Self { .product(name: "URLRouting", package: "swift-url-routing") }
    static var urlFormCoding: Self { .product(name: "URLFormCoding", package: "swift-url-form-coding") }
}

let package = Package(
    name: "swift-url-form-coding-url-routing",
    platforms: [
      .iOS(.v13),
      .macOS(.v10_15),
      .tvOS(.v13),
      .watchOS(.v6),
    ],
    products: [
        .library(name: .urlFormCodingURLRouting, targets: [.urlFormCodingURLRouting]),
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/swift-url-form-coding", from: "0.0.1"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.1.5"),
        .package(url: "https://github.com/pointfreeco/swift-url-routing", from: "0.6.0"),
    ],
    targets: [
        .target(
            name: .urlFormCodingURLRouting,
            dependencies: [
                .urlRouting,
                .urlFormCoding,
            ]
        ),
        .testTarget(
            name: .urlFormCodingURLRouting.tests,
            dependencies: [
                .urlFormCodingURLRouting,
                .dependenciesTestSupport
            ]
        ),
    ],
    swiftLanguageModes: [.v5]
)

extension String { var tests: Self { self + " Tests" } }
