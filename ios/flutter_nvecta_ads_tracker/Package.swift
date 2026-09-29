// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_nvecta_ads_tracker",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "flutter-nvecta-ads-tracker", targets: ["flutter_nvecta_ads_tracker"])
    ],
     dependencies: [
        .package(
            url: "https://github.com/tagnpin/nvecta-ios-sdk.git",
            exact: "1.0.1"
        )
    ],
     targets: [
         .target(
             name: "flutter_nvecta_ads_tracker",
             dependencies: [
                .product(name: "NVECTAAdTrackingSDK", package: "nvecta-ios-sdk"),
             ],
         )
     ]
)