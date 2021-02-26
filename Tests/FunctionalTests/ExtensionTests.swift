/*
 This source file is part of the Swift.org open source project

 Copyright (c) 2021 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See http://swift.org/LICENSE.txt for license information
 See http://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

import XCTest
import SPMTestSupport

import TSCBasic

class ExtensionTests: XCTestCase {
    
    func testUseOfExtensionTargetByExecutableInSamePackage() {
        fixture(name: "Miscellaneous/Extensions/MySourceGenExtension") { path in
            do {
                let (stdout, _) = try executeSwiftBuild(path, configuration: .Debug, env: ["SWIFTPM_ENABLE_EXTENSION_TARGETS": "1"])
                XCTAssert(stdout.contains("Linking MySourceGenTool"), "stdout:\n\(stdout)")
                XCTAssert(stdout.contains("Generating Foo.swift from Foo.dat"), "stdout:\n\(stdout)")
                XCTAssert(stdout.contains("Linking MyLocalTool"), "stdout:\n\(stdout)")
                XCTAssert(stdout.contains("Build Completed"), "stdout:\n\(stdout)")
            }
            catch {
                print(error)
                throw error
            }
        }
    }

    func testUseOfExtensionProductByExecutableAcrossPackages() {
        fixture(name: "Miscellaneous/Extensions") { path in
            do {
                let (stdout, _) = try executeSwiftBuild(path.appending(component: "MySourceGenClient"), configuration: .Debug, env: ["SWIFTPM_ENABLE_EXTENSION_TARGETS": "1"])
                XCTAssert(stdout.contains("Linking MySourceGenTool"), "stdout:\n\(stdout)")
                XCTAssert(stdout.contains("Generating Foo.swift from Foo.dat"), "stdout:\n\(stdout)")
                XCTAssert(stdout.contains("Linking MyTool"), "stdout:\n\(stdout)")
                XCTAssert(stdout.contains("Build Completed"), "stdout:\n\(stdout)")
            }
            catch {
                print(error)
                throw error
            }
        }
    }
}