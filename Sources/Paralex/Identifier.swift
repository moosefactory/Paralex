/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Paralex Framework - v1.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2020 Tristan Leblanc                     */
/*        (oo)             tristan@moosefactory.eu                          */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

//  Created by Tristan Leblanc on 10/12/2021.

import Foundation

// MARK: - IdentifierRole -

/// IdentifierRole
///
/// Tells the type of object that will be awake when the identifier is casted

public struct IdentifierRole: RawRepresentable, Equatable {
    
    // MARK: - Raw Representable Protocol
    
    public var rawValue: String
    
    public init(rawValue: String) { self.rawValue = rawValue }
    
    public init(rawValue: Substring) { self.rawValue = String(rawValue) }
    
    // MARK: - Roles
    
    /// parameter - Generates a parameter - An object that wraps a primitive value, manage clamping and brodcast changes
    /// In UI, parameter will be controled by buttons, toggles, sliders, and any ui component that drives a value.
    public static let parameter = IdentifierRole(rawValue: "parameter")
    
    /// command - Generates a command - A command is a function and does not store any value
    /// In UI, a command will be attached to push buttons, menu items, and any ui component that triggers a basic action
    public static let command = IdentifierRole(rawValue: "command")
    
    /// label - The simplest object. A label is just an object that is used for display purposes
    /// In UI, a label will be attached to static fields, and any ui component that acts as indicators
    public static let label = IdentifierRole(rawValue: "label")
    
    
    /// group - A group is a set of parameters
    public static let group = IdentifierRole(rawValue: "group")
    
}

// MARK: - Identifier -

/// Identifier
///
/// The key stone of this framework.
/// All Parameters and Groups are created by passing an Identifier.
///
/// Identifiers are not mutable
///
/// Identifiers are not hierarchical as parameters and graph nodes.

public struct Identifier: RawRepresentable, Hashable, ParameterBase {
            
    // MARK: Raw Representable Protocol
    
    public typealias RawValue = String
    
    public var rawValue: String
    public var role: IdentifierRole
    
    /// type
    ///
    /// The parameter type ( .void, .bool, .int, .double)
    
    public var type: ParameterType
    
    /// constraint
    ///
    /// The constraint that will be set by default to new parameter created with this identifier.
    
    public var constraint: Constraint?

    // MARK: Displayable Protocol

    public var name: String?
    
    public var symbols: String?

    public init(rawValue: String) {
        self.rawValue = rawValue
        self.role = .label
        self.type = .void
    }
    
    public init(rawValue: String,
                role: IdentifierRole = .label,
                type: ParameterType = .void,
                constraint: Constraint? = nil) {
        self.rawValue = rawValue
        self.role = role
        self.type = type
        self.constraint = constraint
    }
    
    
    /// log
    ///
    /// Returns the string to display in logs.
    /// We don't override the description getter to keep the native representation ( Memory Address )
    
    public var log: String {
        
        var roleString: String = "???\t "
        let constraintString = constraint?.log ?? ""
        switch role {
        case .command:
            roleString = "CMD\t \t "
        case .parameter:
            roleString = "PAR\t\(type)\t\(constraintString)"
        case .label:
            roleString = "LAB\t \t "
        case .group:
            roleString = "GRP\t \t "
        default:
            break
        }
        
        return "\(rawValue)\t\(roleString)"
    }
    
}

// MARK: - Utilities

public extension Identifier {
    
    /// command
    ///
    /// Creates a command identifier
    /// If no name is passed, the raw value is used
    
    static func command(_ identifier: String) -> Identifier {
        Identifier(rawValue: identifier, role: .command, type: .void)
    }
    
    /// parameter
    ///
    /// Creates a parameter identifier
    /// If no name is passed, the identifier raw value is used
    
    static func parameter(_ identifier: String, type: ParameterType, constraint: Constraint? = nil) -> Identifier {
        Identifier(rawValue: identifier, role: .parameter, type: type, constraint: constraint)
    }
    
    /// label
    ///
    /// If no name is passed, the identifier raw value is used
    
    static func label(_ identifier: String, constraint: Constraint? = nil) -> Identifier {
        Identifier(rawValue: identifier, role: .label, type: .void, constraint: constraint)
    }
    
    /// group
    ///
    /// Creates a group identifier
    /// If no name is passed, the raw value is used
    
    static func group(_ identifier: String, constraint: Constraint? = nil) -> Identifier {
        Identifier(rawValue: identifier, role: .group, type: .bool, constraint: constraint)
    }
    
}


// MARK: - Static Identifiers

public extension Identifier {
    static let none = Identifier(rawValue: "none", role: .label, type: .void)
    static let any = Identifier(rawValue: "any", role: .label, type: .void)
    static let all = Identifier(rawValue: "all", role: .label, type: .void)
}

// MARK: - Array Extras

extension Array where Element == Identifier {
    
    public var log: String {
        return map({ $0.log }).joined(separator: "\r")
    }
    
    public func with(string: String) -> Identifier? {
        return first(where: {$0.rawValue == string} )
    }
    
    /// makeParameters
    
    public func makeParameters(in context: Context) throws -> [Parameter] {
        compactMap { try? $0.makeParameter(in: context) }
    }
    
}

