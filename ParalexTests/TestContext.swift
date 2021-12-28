//
//  File.swift
//  
//
//  Created by Tristan Leblanc on 10/12/2021.
//

import Foundation
import AppKit

import Paralex

var context: Context = Context(name: "TestMachine")

extension Identifier {
    static let exampleLabel = Identifier(rawValue: "myLabel", role: .label)
    static let exampleBool = Identifier(rawValue: "myBool", role: .parameter, type: .bool)
    static let exampleInt = Identifier(rawValue: "myInt", role: .parameter, type: .int)
    static let exampleReal = Identifier(rawValue: "myReal", role: .parameter, type: .double)
    static let exampleConstrainedInt = Identifier(rawValue: "myClampedInt", role: .parameter, type: .int)
    static let exampleConstrainedReal = Identifier(rawValue: "myClampedDouble", role: .parameter, type: .double)
    
    static let startCommand = Identifier(rawValue: "start", role: .command)
    static let stopCommand = Identifier(rawValue: "stop", role: .command)
}

struct TestMachine{
    
//    var tree: NSTreeNode
    
    var localizedNamesFile: String? { "ParameterNames" }
    
    var localizedAbbreviationsFile: String? { "ParameterAbbreviations" }
    
    func makeParameter(for identifier: Identifier) -> AnyParameter? {
        return try? identifier.makeParameter(in: context)
    }
    
    func constraint(for identifier: Identifier) -> Constraint? {
        switch identifier {
        case .exampleConstrainedInt:
            return Constraint(doubleMin: 0, granularity: 1, defaultValue: 4)
        case .exampleConstrainedReal:
            return Constraint(doubleMin: -1, doubleMax: 1, granularity: 0.1, defaultValue: 0)
        default:
            return nil
        }
    }
    
    var localizationFile: String?

    var allIdentifiers: [Identifier] = [
        .exampleLabel,
        .exampleBool,
        .exampleInt,
        .exampleReal,
        .exampleConstrainedInt,
        .exampleConstrainedReal,
        .startCommand,
        .stopCommand
    ]
    
    
    func test_01_LabelInfo() throws {
        testSection("3 - Test identifier with label info") {
            
            var identifier = Identifier(rawValue: "labeledIdentifier", role: .label)
           
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
