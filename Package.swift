// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Microcosm",
	platforms: [.iOS(.v16), .macOS(.v15)],
	products: [
		// Products define the executables and libraries a package produces, making them visible to other packages.
		.library(
			name: "Microcosm",
			targets: ["Microcosm"]
		),
		.library(name: "MicrocosmMocks", targets: ["MicrocosmMocks"]),
	],
	dependencies: [
		.package(
			//0.5.1 is the release that makes VerificationMethod.init public
			url: "https://github.com/germ-network/AtprotoTypes.git",
			from: "0.5.1"
		),
		.package(
			url: "https://github.com/germ-network/GermConvenience.git",
			// 0.14.0 is the floor AtprotoClient 0.12.0 needs; the tests use
			// GermConvenienceURLSession, where URLSession's HTTPFetcher
			// conformance lives.
			from: "0.14.0"
		),
		//0.12.0 requires GermConvenience 0.14.0.
		.package(
			url: "https://github.com/germ-network/AtprotoClient.git",
			from: "0.12.0"
		),
		.package(url: "https://github.com/apple/swift-http-types.git", from: "1.5.1"),
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "Microcosm",
			dependencies: [
				"AtprotoTypes",
				"AtprotoClient",
				"GermConvenience",
				.product(name: "GermConvenienceHTTP", package: "GermConvenience"),
				.product(name: "HTTPTypes", package: "swift-http-types"),
			]
		),
		.target(
			name: "MicrocosmMocks",
			dependencies: [
				"Microcosm",
				.product(name: "AtprotoTypesMocks", package: "AtprotoTypes"),
				.product(name: "Mockable", package: "AtprotoTypes"),
			]
		),
		.testTarget(
			name: "MicrocosmTests",
			dependencies: [
				"Microcosm",
				"MicrocosmMocks",
				.product(name: "AtprotoTypesVerify", package: "AtprotoTypes"),
				.product(name: "GermConvenienceURLSession", package: "GermConvenience"),
			]
		),
	]
)
