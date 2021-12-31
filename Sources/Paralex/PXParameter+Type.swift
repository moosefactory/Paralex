/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Paralex Framework - v1.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2020 Tristan Leblanc                     */
/*        (oo)             tristan@moosefactory.eu                          */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

//  Created by Tristan Leblanc on 10/12/2021.

import Foundation


public struct PXParameterType: RawRepresentable, Equatable, Loggable {
    
    // MARK: - RawRepresentable Protocol
    
    public typealias RawValue = String
    
    public var rawValue: RawValue
    
    // MARK: - Equatable Protocol
    public static func == (lhs: Self, rhs: Self) -> Bool { lhs.rawValue == rhs.rawValue }
    public static func != (lhs: Self, rhs: Self) -> Bool { lhs.rawValue != rhs.rawValue }
    
    // MARK: - Initialisation
    
    public init(_ rawValueOrNil: String?) {
        self.init(rawValue: rawValueOrNil ?? "void")
    }
    
    public init(rawValue: RawValue) { self.rawValue = rawValue }
    
    // MARK: - Paralex base types
    
    public static let void = PXParameterType(rawValue: "void")
    public static let bool = PXParameterType(rawValue: "bool")
    public static let int = PXParameterType(rawValue: "int")
    public static let double = PXParameterType(rawValue: "double")
    
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
    
    // MARK: - Loggable Protocol

    public var log: String {
        rawValue
    }
}
