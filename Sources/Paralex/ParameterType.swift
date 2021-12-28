/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Paralex Framework - v1.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2020 Tristan Leblanc                     */
/*        (oo)             tristan@moosefactory.eu                          */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

//  Created by Tristan Leblanc on 10/12/2021.

import Foundation

public struct ParameterType: RawRepresentable, Equatable, CustomStringConvertible {
    
    // MARK: - RawRepresentable Protocol
    
    public typealias RawValue = String
    public var rawValue: RawValue
    
    // MARK: - Equatable Protocol
    public static func == (lhs: ParameterType, rhs: ParameterType) -> Bool { lhs.rawValue == rhs.rawValue }
    public static func != (lhs: ParameterType, rhs: ParameterType) -> Bool { lhs.rawValue != rhs.rawValue }

    // MARK: - Initialisation
    
    public init(_ rawValueOrNil: String?) {
        self.init(rawValue: rawValueOrNil ?? "void")
    }
    
    public init(rawValue: RawValue) { self.rawValue = rawValue }
    
    // MARK: - Paralex base types
    
    public static let void = ParameterType(rawValue: "void")
    public static let bool = ParameterType(rawValue: "bool")
    public static let int = ParameterType(rawValue: "int")
    public static let double = ParameterType(rawValue: "double")
    
    // MARK: - Paralex base types

    var defaultFormatter: Formatter {
        switch self {
        case .double:
            return Formatter.realFormatter
        case .int:
            return Formatter.intFormatter
        case .bool:
            return Formatter.boolFormatter
        default:
            return NumberFormatter()
        }
    }

    public var description: String {
        rawValue
    }
}
