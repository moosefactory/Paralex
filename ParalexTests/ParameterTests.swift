/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        Paralex Framework                                */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2021 Tristan Leblanc                          */
/*        (oo)             tristan@moosefactory.eu                          */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

//  ParameterTests.swift
//  Created by Tristan Leblanc on 15/12/2021.

import XCTest
@testable import Paralex

final class ParameterTests: XCTestCase {
    
    func test_01_BoolParameter() throws {
        
        testSection("1 - Test BoolParameter") {
            
            let param = BoolParameter(Identifier(rawValue: "myBool"))
            XCTAssert(param.value == false)
            let cancellable = param.$value.sink { completion in
                print("Parameter \(param.log) changed")
            } receiveValue: { value in
                print("\(param.log) Parameter $value will change to \(value)")
            }
            
            param.value = true
            
            print(param.log)
            XCTAssert(param.value == true)
        }
    }
    
    func test_02_IntParameter() throws {
        
        testSection("Test IntParameter") {
            
            let param = IntParameter(Identifier(rawValue: "myInt", name: "Integer"), value: 3)
            XCTAssert(param.value == 3)
            let cancellable = param.$value.sink { completion in
                print("Parameter \(param.log) changed")
            } receiveValue: { value in
                print("\(param.log) Parameter $value will change to \(value)")
            }
            
            param.value = 5
            print(param.log)
            XCTAssert(param.value == 5)
            
            param.value = -5
            print(param.log)
            XCTAssert(param.value == -5)
            
            printSection("Test IntParameter with Constraint")
            
            let constraint = Constraint(doubleMin: -2, doubleMax: 2, granularity: 1, defaultValue: 2)
            
            print("Will set constraint \(constraint)")
            param.constraint = constraint
            
            print(param.log)
        }
    }
    
    func test_03_DoubleParameter() throws {
        
        testSection("Test DoubleParameter") {
            
            let param = IntParameter(Identifier(rawValue: "myDouble", name: "Integer"), value: 3)
            XCTAssert(param.value == 3)
            let cancellable = param.$value.sink { completion in
                print("Parameter \(param.log) changed")
            } receiveValue: { value in
                print("\(param.log) Parameter $value will change to \(value)")
            }
            
            param.value = 5
            print(param.log)
            XCTAssert(param.value == 5)
            
            param.value = -5
            print(param.log)
            XCTAssert(param.value == -5)
            
            printSection("Test DoubleParameter with Constraint")
            
            let constraint = Constraint(doubleMin: -2, doubleMax: 2, granularity: 1, defaultValue: 2)
            
            print("Will set constraint \(constraint)")
            param.constraint = constraint
            
            print(param.log)
        }
    }
}
