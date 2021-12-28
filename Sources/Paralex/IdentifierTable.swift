/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Paralex Framework - v1.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2020 Tristan Leblanc                     */
/*        (oo)             tristan@moosefactory.eu                          */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

//  Created by Tristan Leblanc on 15/12/2021.

import Foundation
#if targetEnvironment(macCatalyst)
import AppKit
#endif
struct IdentifierTable {
    
    enum Err: Error {
        case rawValueNotSpecified
    }
    
    private var url: URL?
    private var lines: [String]?
    private var lazy: Bool = false
    
    private(set) var identifiers: [Identifier] = []
    
    // MARK: - Initialisation
    
    init(url: URL, lazy: Bool = false) throws {
        self.url = url
        if !lazy {
            try load()
        }
    }
    
    init(lines: [String], lazy: Bool = false) throws {
        self.lines = lines
        if !lazy {
            try awake()
        }
    }
    
    /// load
    ///
    /// If an url is set, it loads the file and create Identifier objects

    mutating func load() throws {
        guard let url = url else {
            return
        }
        let string = try String(contentsOf: url)
        lines = string.split(separator: "\r").map { String($0) }
        try awake()
    }
    
    /// awake
    ///
    /// Create Identifier objects from definitions in table
    
    mutating func awake() throws {
        guard let lines = lines else {
            return
        }
        self.lines = lines
        identifiers = lines.compactMap { try? Identifier(tableEntry: $0) }
    }
    
    public func makeParameters(in context: Context) throws -> [Parameter] {
        return try identifiers.makeParameters(in: context)
    }
}

extension Identifier {
    
    fileprivate init(tableEntry: String) throws {
        
        func str(_ index: Int) -> String? {
            let _str = values.count > index ? String(values[index]) : " "
            return _str != " " && !_str.isEmpty ? _str : nil
        }
        
        let values = tableEntry.split(separator: ";")
        
        guard values.count > 1 else {
            throw IdentifierTable.Err.rawValueNotSpecified
        }
        
        let role = IdentifierRole(rawValue: values[0])

        let rawValue = str(1)!
        let type = ParameterType(str(2))
        let constraint: Constraint? = values.count > 3 ? (try? Constraint(string: str(3))) : nil
        self.init(rawValue: rawValue, role: role, type: type, constraint: constraint)

    }
}

extension Constraint {
        
    /// init
    ///
    /// Creates a constraint from a formatted string : "[min,max,granularity,default]"
    
    convenience init?(string: String?) throws {
        guard let string = string else { return nil }
        guard let start = string.firstIndex(of: "["), let end = string.firstIndex(of: "]") else {
            throw IdentifierTable.Err.rawValueNotSpecified
        }

        func str(_ index: Int) -> String? {
            let _str = values.count > index ? String(values[index]) : " "
            return _str != " " && !_str.isEmpty ? _str : nil
        }

        func double(_ index: Int) -> Double? {
            guard let s = str(index) else { return nil }
            return Double(s)
        }
        let s = string.index(after: start)
        let e = string.index(before: end)
        let stringWithoutBrackets = string[s...e]
        let values = stringWithoutBrackets.split(separator: ",")
   
        self.init(doubleMin: double(0), doubleMax: double(1), granularity: double(2), defaultValue: double(3))
    }
}
