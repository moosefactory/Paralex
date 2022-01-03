/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Paralex Framework - v1.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2020 Tristan Leblanc                     */
/*        (oo)             tristan@moosefactory.eu                          */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

//  Created by Tristan Leblanc on 19/12/2021.

import Foundation
import SwiftUI

// MARK: - PXParameter

/// PXParameter
///
/// PXParameter is an observable object by itself.
///
/// - An objectChange message is sent each time an impacting property is changed
/// - The double value is a published value.

open class PXParameter : ObservableObject, Identifiable {
    
    public let uuid: UUID = UUID()
    
    public let identifier: PXIdentifier
    
    public var owner: PXGroup?
    
    // MARK: Mutable Properties
    
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
    
    @Published public var doubleValue: Double = 0
    
    public var constraint: PXConstraint? { didSet {
        objectWillChange.send()
    }}
    
    
    public var formatter: Formatter? { didSet {
        objectWillChange.send()
    }}
    
    public var isActive: Bool { didSet {
        objectWillChange.send()
    }}
    
    // MARK: Private properties
    
    public var innerValue: Double
    
    public var context: PXContext? { owner?.context }
    
    // MARK: - Initialisation
    
    public init(_ identifier: PXIdentifier,
                in group: PXGroup?,
                doubleValue: Double? = nil,
                constraint: PXConstraint? = nil,
                formatter: Formatter? = nil) {
        self.identifier = identifier
        self.owner = group
        innerValue = doubleValue ?? constraint?.defaultValue ?? 0
        self.doubleValue = constraint?.apply(to: innerValue) ?? innerValue
        // Use passed constraint, or default identifier constraint if nil
        self.constraint = constraint ?? identifier.constraint
        self.formatter = formatter
        isActive = true
        self.applyConstraint(setDefault: true)
        
        group?.parameters.append(self)
    }

    // MARK: - Loggable {
    
    /// log
    ///
    /// Returns the string to display in logs.
    /// We don't override the description getter to keep the native representation ( Memory Address )
    
    public var log: String {
        return "\(identifier.log)\t\(formattedValue)"
    }
}

extension PXParameter {    
    
    /// The integer value
    public var double: Double { get { doubleValue } set { doubleValue = newValue } }
    
    /// The integer value
    public var int: Int { get { Int(doubleValue) } set { doubleValue = Double(newValue) } }
    
    /// The boolean value
    public var bool: Bool { get { doubleValue > 0 } set { doubleValue = newValue ? 1 : 0 } }
    
    public func offsetValue(by offset: Double) {
        var newValue = doubleValue + offset
        applyConstraint(to: &newValue)
        print("Constrained : \(newValue)")
        doubleValue = newValue
    }
}


// MARK: - Constraints -

public extension PXParameter {
    
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
