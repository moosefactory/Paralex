/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Paralex Framework - v1.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2020 Tristan Leblanc                     */
/*        (oo)             tristan@moosefactory.eu                          */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

//  Created by Tristan Leblanc on 14/12/2021.

import Foundation

/// ParameterBase
///
/// The base protocol for parameters and identifiers
///
/// Identifiers and Parameters are both based on this protocol.
///
/// Identifiers use this information to:
///     - Create the parameter
///     - Give relevant informations to the UI, even if a parameter is not set yet
///
/// Parameters are first created from the identifier, and inherits of all properties values
/// They can then be modified for special needs. A common case is the constraint modification.
///
/// ParameterBase constraints can be overiden by parameters.

public protocol ParameterBase {
    
    /// The constraint that will be set to the created parameter
    
    var constraint: Constraint? { get }
    
    /// The type of parameter ( bool, int, double )
    
    var type: ParameterType { get }
}

/// AnyParameter
///
/// The parameter protocol, used to pass or returns parameters to generic functions

public protocol AnyParameter: AnyObject, ParameterBase, Identified {
    
    var context: Context? { get }
    
    /// Unique UUID
    
    var uuid: UUID { get }
    
    /// The parameter identifier

    var identifier: Identifier { get }

    /// The formatter to use to generate the formatted value

    var formatter: Formatter? { get }
    
    /// The formatted value, to use in UI or logs

    var formattedValue: String { get }
    
    /// The double parameter value.
    /// All Paralex parameters values are double.
    /// This is designed this way to allow parameters combinations.
    ///
    /// For example an oscillator could generate a sinus signal to set the value of a boolean parameter.
    /// The parameter would then be true if the value is > 0 and false otherwise.
    ///
    /// The double value will be published, while the inner value won't.
    /// Suppose a boolean parameter is listened somewhere in the app, the listener won't receive all changes.
    /// if the innerValue changes, it would trigger messages for any little change.
    /// Rather, the double value is listened. If a constraint is set,
    /// Double value will change only from it's type definition, by the constraint granularity ( ∂ ) value, and if it is in the constraint range.
    /// See here an example of variation, and how the values are published ( published when there is a 􀬲 )
    ///
    /// Inner Value              :  |    0.0  􀬲  |    0.3    |    0.6    |    0.9    |    1.2    |    1.5    |
    ///
    /// Bool Param               :  |   false 􀬲  |   true 􀬲 |   true    |   true    |   true    |   true    |
    /// Int Param                :  |     0   􀬲  |     0     |     0     |     0     |     1  􀬲 |     1     |
    /// Double Value ( ∂ = 0.5 ) :  |    0.0  􀬲  |    0.0    |    0.5 􀬲 |    0.5    |    1.0 􀬲 |    1.0    |
    
    var doubleValue: Double { get set }

    /// The inner parameter value.
    /// All Paralex parameters intrinsic values are double.
    
    var innerValue: Double { get set }
    
    /// isActive
    ///
    /// A parameter can be active or not.
    /// When inactive, the doubleValue is always 0. The innerValue is ignored
    /// When active, the doubleValue is the inner value, constrained if any constraint is set.
    ///
    var isActive: Bool { get set }
}

extension AnyParameter {
    
    /// The integer value
    var double: Double { get { doubleValue } set { doubleValue = newValue } }

    /// The integer value
    public var int: Int { get { Int(doubleValue) } set { doubleValue = Double(newValue) } }
    
    /// The boolean value
    public var bool: Bool { get { doubleValue > 0 } set { doubleValue = newValue ? 1 : 0 } }

}

// MARK: - Constraint

public extension AnyParameter {

    /// applyConstraint
    ///
    /// Apply the constraint - pass setDefault to true when called from parameter init,
    /// or if the UI let the user reset a parameter ( by clicking slider with control key for example )
    func applyConstraint(setDefault: Bool = false, to value: inout Double) {
        guard let constraint = constraint else { return }
        
        if setDefault, let defaultValue = constraint.defaultValue {
            value = defaultValue
        }
        if let min = constraint.doubleMin, value < min {
            value = min
        }
        if let max = constraint.doubleMax, value > max {
            value = max
        }
        if let granularity = constraint.granularity, granularity > 0 {
            
        }
    }

    func applyConstraint(setDefault: Bool = false) {
        applyConstraint(setDefault: setDefault, to: &doubleValue)
    }
}

// MARK: - Parameter Commons

extension AnyParameter {

    public var slug: String {
        return identifier.rawValue
    }

    /// log
    ///
    /// Returns the string to display in logs.
    /// We don't override the description getter to keep the native representation ( Memory Address )
    
    public var log: String {
        return "\(identifier.log)\t\(formattedValue)"
    }
    
    /// formattedValue
    ///
    /// Returns the value formatted by a standard Formatter object
    
    public var formattedValue: String {
        let formatter: Formatter = formatter ?? type.defaultFormatter
        return formatter.string(for: doubleValue) ?? "\(doubleValue)"
    }
}


