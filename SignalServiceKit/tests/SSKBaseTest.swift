//
// Copyright 2018 Signal Messenger, LLC
// SPDX-License-Identifier: AGPL-3.0-only
//

public import XCTest
@testable public import SignalServiceKit
import CocoaLumberjack

public class SSKBaseTest: XCTestCase {
    @MainActor
    public override func setUp() {
        DDLog.add(DDTTYLogger.sharedInstance!)
        let setupExpectation = expectation(description: "mock ssk environment setup completed")
        Task {
            await MockSSKEnvironment.activate()
            setupExpectation.fulfill()
        }
        waitForExpectations(timeout: 2)
    }

    public override func tearDown() {
        MockSSKEnvironment.flushAndWait()
        super.tearDown()
    }

    public func read(_ block: (SDSAnyReadTransaction) -> Void) {
        return SSKEnvironment.shared.databaseStorageRef.read(block: block)
    }

    public func write<T>(_ block: (SDSAnyWriteTransaction) -> T) -> T {
        return SSKEnvironment.shared.databaseStorageRef.write(block: block)
    }

    public func write<T>(_ block: (SDSAnyWriteTransaction) throws -> T) rethrows -> T {
        try SSKEnvironment.shared.databaseStorageRef.write(block: block)
    }

    public func asyncWrite(_ block: @escaping (SDSAnyWriteTransaction) -> Void) {
        return SSKEnvironment.shared.databaseStorageRef.asyncWrite(block: block)
    }
}
