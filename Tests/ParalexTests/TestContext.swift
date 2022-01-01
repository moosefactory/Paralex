//
//  File.swift
//  
//
//  Created by Tristan Leblanc on 10/12/2021.
//

import XCTest
@testable import Paralex

var context: PXContext = PXContext(name: "TestMachine")

extension PXIdentifier {
    
    static let machine = group("machine")
    
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
    
    
    func identifiersInGroup(with identifier: PXIdentifier) throws -> [PXIdentifier] {
        switch identifier {
        case .machine:
            return [
                .parameters, .commands
            ]
        case .parameters:
            return [
                .exampleLabel, .exampleBool, .exampleInt, .exampleReal, .exampleConstrainedInt, .exampleConstrainedReal
            ]
        case .commands:
            return [
                .startCommand, .stopCommand
            ]
        default:
            return []
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
            self.root = try factory.makeRoot(with: .machine)
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
}

final class TestFullMachine: XCTestCase {
    
    func test_01_Machine() throws {
        try testSection("3 - Test machine ( PXContainer )") {
            
            var machine = try TestMachine()
            
            print(machine.root.hierarchicalLog)
            
            let parameter = machine.parameter(with: "machine.parameters.myInt")
            print("parameters.myInt = \(parameter)")
            XCTAssert(parameter?.identifier == .exampleInt)
        }
    }
}


final class TestLabel: XCTestCase {
    
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
