//
//  IdentifierTable.swift
//  
//
//  Created by Tristan Leblanc on 15/12/2021.
//

import XCTest
@testable import Paralex

final class IdentifierTableTests: XCTestCase {
    
    func testIdentifierTable() throws {
        
        // type id  name    shortName   abbr.   symbol  type    constraint
        let table = try IdentifierTable(lines: [
            "command;start;Start; ; ;▶️",
            "command;pause;Pause; ; ;⏸",
            "command;stop;Stop; ; ;⏹",
            "parameter;myBool;bool;My Bool;Bool;B;􀁚",
            "parameter;myInt;int;My Int;Int;I;􀁚",
            "parameter;myDouble;double;[-1,1,0.1,0];My Double;Double;V;􀁚"
        ])
        
        printSection("Identifier Table Log")
        print(table.identifiers.log)
        printSection("Parameters Table Log")
        
        let parameters = table.identifiers.compactMap( { try? $0.makeParameter() } )
        print(parameters.log)
        
        printSection("Apply Values to Parameters Table Log")
        
        let b = parameters.with(string: "myBool")!
        let i = parameters.with(string: "myInt")!
        let d = parameters.with(string: "myDouble")!

        let params = [b, i, d]
        for n in -10...10 {
            let v = Double(n) / 10
            
            print("---> Set \(v)")
            params.set(doubleValue:v)
            print(params.log)
        }
    }
}
