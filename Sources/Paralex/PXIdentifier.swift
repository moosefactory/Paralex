/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Paralex Framework - v1.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2020 Tristan Leblanc                     */
/*        (oo)             tristan@moosefactory.eu                          */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

//  Created by Tristan Leblanc on 10/12/2021.

import Foundation

// MARK: - PXIdentifier -

/// PXIdentifier
///
/// The key stone of this framework.
/// All Parameters and Groups are created by passing a PXIdentifier.
///
/// - PXIdentifiers are not mutable
/// - PXIdentifiers provides some information about the parameter to create when casted
///     - The data type : void, bool, int or double
///     - The constraint that sets value bounds, default value and granularity. This can be overriden by the PXParameter
///
/// - PXIdentifiers are not hierarchical. It is a flat list. Paralex means "Parameters Lexicon"
///   The PXContext object is responsible of returning the PXParameters hierarchicaly.
///
/// - PXIdentifiers can be used to define various parameters. For exemple a "intensity" identifier could be used
///   to add an intensity parameter to various groups.

public struct PXIdentifier: RawRepresentable, Hashable, ParameterBase {
    
    public var id = UUID()
    
    // MARK: Raw Representable Protocol
    
    public typealias RawValue = String
    
    public var rawValue: String
    
    public var role: IdentifierRole
    
    /// type
    ///
    /// The parameter type ( .void, .bool, .int, .double)
    
    public var type: PXParameterType
    
    /// constraint
    ///
    /// The constraint that will be set by default to new parameter created with this identifier.
    
    public var constraint: PXConstraint?

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
                type: PXParameterType = .void,
                constraint: PXConstraint? = nil) {
        self.rawValue = rawValue
        self.role = role
        self.type = type
        self.constraint = constraint
    }
    
    // Returns the name to display - this should be managed by context, but we let it as is for now for backward compatibility
    public var displayName: String {
        name ?? rawValue
    }
    
    public var isGroup: Bool { return role == .group }
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


// MARK: - Static Identifiers

public extension PXIdentifier {
    static let none = PXIdentifier(rawValue: "none", role: .label, type: .void)
    static let any = PXIdentifier(rawValue: "any", role: .label, type: .void)
    static let all = PXIdentifier(rawValue: "all", role: .label, type: .void)
}

// MARK: - Array Extras

extension Array where Element == PXIdentifier {
    
    public var log: String {
        return map({ $0.log }).joined(separator: "\r")
    }
    
    public func with(string: String) -> PXIdentifier? {
        return first(where: {$0.rawValue == string} )
    }
}


//extension Parameter {
//    func makeParameter(in context: PXContext) -> Parameter {
//        return identifier.make
//    }
//}
//
