//
//  GraphTests.swift
//  
//
//  Created by Tristan Leblanc on 15/12/2021.
//

import XCTest
@testable import Paralex

final class GraphTests: XCTestCase {
    
    func testGraph() throws {
        
        let machineId = Identifier(rawValue: "machine")
        let transportId = Identifier(rawValue: "transport")
        
        
        let transport_table = try IdentifierTable(lines: [
            "command;start",
            "command;pause",
            "command;stop"
        ])
        
        let machine_table = try IdentifierTable(lines: [
            "parameter;myBool",
            "parameter;myInt",
            "parameter;myDouble"
        ])
        
        let transport_params = try transport_table.makeParameters(in: context)
        let machine_params = try machine_table.makeParameters(in: context)

        let transport_group = ParametersGroup(identifier: transportId, parameters: transport_params)
        let machineGroup = ParametersGroup(identifier: machineId, parameters: machine_params)
        
        let graph = Graph(rootGroup: machineGroup)
        let transportNode = GroupGraphNode(group: transport_group, in: graph.root)
        
        printSection("Graph Test 1 - log")
        print(graph.log)
    }
}
