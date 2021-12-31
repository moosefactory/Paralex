//
//  File.swift
//  
//
//  Created by Tristan Leblanc on 10/12/2021.
//

import Foundation
import AppKit

import Paralex

var context: PXContext = PXContext(name: "TestMachine")

extension PXIdentifier {
    
    static let machine = PXIdentifier(rawValue: "machine", role: .label)
    
    static let parameters = group("parameters")
    
    static let exampleLabel = label("myLabel")
    static let exampleBool = bool("myBool")
    static let exampleInt = int("myInt")
    static let exampleReal = double("myReal")
    static let exampleConstrainedInt = int("myClampedInt",
                                           constraint: PXConstraint(doubleMin: 0, granularity: 1, defaultValue: 4))
    static let exampleConstrainedReal = double("myClampedDouble",
                                               constraint: PXConstraint(doubleMin: -1, doubleMax: 1, granularity: 0.1, defaultValue: 0))
    
    static let commands = group("commands")
    
    static let startCommand = command("start")
    static let stopCommand = command("stop")
}

struct TestFactory: PXFactory {
    
    func constraint(for identifier: PXIdentifier) throws -> PXConstraint? {
        nil
    }
    
    func makeGroup(with identifier: PXIdentifier, in group: PXGroup? = nil) throws -> PXGroup {
        let identifiers = try identifiersInGroup(with: identifier)
        let group = try PXGroup(identifier: identifier, in: group, parameters: [])
        
        let parameters = try identifiers.makeParameters(in: group)
        
        return group
    }
    
    func identifiersInGroup(with identifier: PXIdentifier) throws -> [PXIdentifier] {
        if identifier == .machine {
            return [
                .exampleLabel, .exampleBool, .exampleInt, .exampleReal, .exampleConstrainedInt, .exampleConstrainedReal,
                .startCommand, .stopCommand
            ]
        }
        return []
    }
}

struct TestMachine: PXContainer {
    
    var root: PXGroup
    
    var factory: PXFactory
    
    func constraint(for identifier: PXIdentifier) throws -> PXConstraint? {
        return nil
    }
    
    var context: PXContext
    
    
    
    init() {
        context = TestContext()
        factory = TestFactory()
        
        do {
            self.root = try factory.makeGroup(with: .machine, in: nil)
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    
    func test_01_LabelInfo() throws {
        testSection("3 - Test identifier with label info") {
            
            var identifier = PXIdentifier(rawValue: "labeledIdentifier", role: .label)
            
            var labelInfo = context.localizedLabel(for: identifier)
            
            print(labelInfo.log)
            
            print("Symbol 0 : \(labelInfo.symbol)")
            labelInfo.symbolIndex = 1
            print("Symbol 1 : \(labelInfo.symbol)")
            labelInfo.symbolIndex = 2
            print("Symbol 2 : \(labelInfo.symbol)")
        }
    }
}
