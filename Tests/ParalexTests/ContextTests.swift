//
//  FactoryTests.swift
//  
//
//  Created by Tristan Leblanc on 10/12/2021.
//

import XCTest
@testable import Paralex

final class FactoryTests: XCTestCase {
    
    func testFactory() throws {
        
        let machine = TestMachine()
        
        machine.allIdentifiers.forEach { identifier in
            if let param = machine.makeParameter(for: identifier) {
                print(param.log)
            } else {
                print("error")
            }
        }
    }
}
