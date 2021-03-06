//
//  TestIdentifier.m
//  
//
//  Created by Tristan Leblanc on 10/12/2021.
//
import XCTest
@testable import Paralex

class TestContext: PXContext {

    public init() {
        super.init(name: "TestContext")
    }
    
    override func symbols(for identifier: PXIdentifier) -> String? {
        switch identifier.rawValue {
        case "labeledIdentifier":
            return "􀊴􀊵"
        default:
            return nil
        }
    }

}

final class TestIdentifier: XCTestCase {
    
    func test_01_Roles() throws {
        printSection("1 - Test Identifier roles")
        print("---> Make identifier with roles [.parameter, .group, .command, .label]")
        
        let roles: [IdentifierRole] = [.parameter, .group, .command, .label]
        for role in roles {
            let identifier = PXIdentifier(rawValue: "\(role.rawValue)Testidentifier", role: role, type: .void, constraint: nil)
            print(identifier.log)
        }
    }
    
    func test_02_Types() throws {
        testSection("2 - Test parameter identifier types") {
            print("---> Make identifier with types [.void, .bool, .int, .double]")
            
            let types: [PXParameterType] = [.void, .bool, .int, .double]
            for type in types {
                let identifier = PXIdentifier(rawValue: "\(type.rawValue)Testidentifier", role: .parameter, type: type, constraint: nil)
                print(identifier.log)
            }
        }
    }
    
}

