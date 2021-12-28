//
//  TestParameterGroup.swift
//  ParalexTests
//
//  Created by Tristan Leblanc on 26/12/2021.
//

import XCTest
@testable import Paralex

final class TestParameterGroup: XCTestCase {
    

    func test_01_Group() throws {
        

        let groupB = ParametersGroup(identifier: Identifier(rawValue: "groupB", role: .group), parameters: [
            try Identifier(rawValue: "pB1", role: .parameter).makeParameter(in: context),
            try Identifier(rawValue: "pB2", role: .parameter).makeParameter(in: context)
        ])

        let groupD = ParametersGroup(identifier: Identifier(rawValue: "groupD", role: .group), parameters: [
            try Identifier(rawValue: "pD1", role: .parameter).makeParameter(in: context),
            try Identifier(rawValue: "pD2", role: .parameter).makeParameter(in: context)
        ])

        let groupC = ParametersGroup(identifier: Identifier(rawValue: "groupC", role: .group), parameters: [
            try Identifier(rawValue: "pC1", role: .parameter).makeParameter(in: context),
            try Identifier(rawValue: "pC2", role: .parameter).makeParameter(in: context)
        ], subGroups: [groupD])

        let groupA = ParametersGroup(identifier: Identifier(rawValue: "groupA", role: .group), parameters: [
            try Identifier(rawValue: "pA1", role: .parameter).makeParameter(in: context),
            try Identifier(rawValue: "pA2", role: .parameter).makeParameter(in: context)
        ], subGroups: [groupB, groupC])

        testSection("1 - Test Parameter groups") {
            print(groupA.log)
        }
        
        testSection("2 - Test Graph") {
            let graph = GroupGraphNode(group: groupA)
            print(graph.log)
        }


    }

}
