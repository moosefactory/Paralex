//
//  TestParameterGroup.swift
//  ParalexTests
//
//  Created by Tristan Leblanc on 26/12/2021.
//

import XCTest
@testable import Paralex

final class TestParameterGroup: XCTestCase {
    
    let testContext = TestContext()
    
    func test_01_Group() throws {
        
        let groupB = try PXGroup(identifier: PXIdentifier(rawValue: "groupB", role: .group), in: testContext , parameters: [
            try PXIdentifier(rawValue: "pB1", role: .parameter).makeParameter(in: context),
            try PXIdentifier(rawValue: "pB2", role: .parameter).makeParameter(in: context)
        ])

        let groupD = try PXGroup(identifier: PXIdentifier(rawValue: "groupD", role: .group), in: testContext , parameters: [
            try PXIdentifier(rawValue: "pD1", role: .parameter).makeParameter(in: context),
            try PXIdentifier(rawValue: "pD2", role: .parameter).makeParameter(in: context)
        ])

        let groupC = try PXGroup(identifier: PXIdentifier(rawValue: "groupC", role: .group), in: testContext , parameters: [
            try PXIdentifier(rawValue: "pC1", role: .parameter).makeParameter(in: context),
            try PXIdentifier(rawValue: "pC2", role: .parameter).makeParameter(in: context),
            groupD
        ])

        let groupA = try PXGroup(identifier: PXIdentifier(rawValue: "groupA", role: .group), in: testContext , parameters: [
            try PXIdentifier(rawValue: "pA1", role: .parameter).makeParameter(in: context),
            try PXIdentifier(rawValue: "pA2", role: .parameter).makeParameter(in: context),
            groupB,
            groupC
        ])

        testSection("1 - Test PXGroup") {
            print(groupA.log)
        }
    }

}
