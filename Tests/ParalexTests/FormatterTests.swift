//
//  FormatterTests.swift
//  
//
//  Created by Tristan Leblanc on 15/12/2021.
//

import XCTest
@testable import Paralex

final class FormatterTests: XCTestCase {
    
    func testBoolFormatter() throws {
        let f = BoolFormatter.boolFormatter
        printSection("Bool Formatter")
        print(f.string(for: -0.5)!)
        XCTAssert(f.string(for: -0.5) == "False")
        print(f.string(for: 0)!)
        XCTAssert(f.string(for: 0) == "False")
        print(f.string(for: 0.5)!)
        XCTAssert(f.string(for: 0.5) == "True")
    }

    func testOnOffFormatter() throws {
        let f = BoolFormatter.onOffFormatter
        printSection("onOffFormatter")
        print(f.string(for: -0.5)!)
        XCTAssert(f.string(for: -0.5) == "Off")
        print(f.string(for: 0)!)
        XCTAssert(f.string(for: 0) == "Off")
        print(f.string(for: 0.5)!)
        XCTAssert(f.string(for: 0.5) == "On")
    }

    func testOnOffSymbolFormatter() throws {
        let f = BoolFormatter.onOffSymbolFormatter
        printSection("onOffSymbolFormatter")
        print(f.string(for: -0.5)!)
        XCTAssert(f.string(for: -0.5) == "􀷃")
        print(f.string(for: 0)!)
        XCTAssert(f.string(for: 0) == "􀷃")
        print(f.string(for: 0.5)!)
        XCTAssert(f.string(for: 0.5) == "􀷄")
    }

    func testYesNoFormatter() throws {
        let f = BoolFormatter.yesNoFormatter
        printSection("yesNoFormatter")
        print(f.string(for: -0.5)!)
        XCTAssert(f.string(for: -0.5) == "No")
        print(f.string(for: 0)!)
        XCTAssert(f.string(for: 0) == "No")
        print(f.string(for: 0.5)!)
        XCTAssert(f.string(for: 0.5) == "Yes")
    }
}
