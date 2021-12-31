/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Paralex Framework - v1.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2020 Tristan Leblanc                     */
/*        (oo)             tristan@moosefactory.eu                          */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

//  Created by Tristan Leblanc on 14/12/2021.

import Foundation

/// Constraint
///
/// Any parameter can be attached to a constraint object that will clamp and round the value.
/// It also provides a default value.

public class PXConstraint: Loggable {
    
    /// The parameter minimum value - -∞ if nil
    
    public var doubleMin: Double?
    
    /// The parameter maximum value - +∞ if nil
    
    public var doubleMax: Double?
    
    /// The parameter granularity.
    /// For example a double parameter with a 0.5 granularity will always return values as
    /// (…, -0.5, 0, 0.5, 1, 1.5, …)
    /// Note that the inner value is not affected by rounding
    
    public var granularity: Double?
    
    /// The default value to use when creating a new parameter, or if the UI allows parameter reset
    /// ( Like ctrl+click on a control to reset it's value - this is up to the developper )
    
    public var defaultValue: Double?
    
    // MARK: - Initialisation
    
    public init(doubleMin: Double? = nil,
                doubleMax: Double? = nil,
                granularity: Double? = nil,
                defaultValue: Double? = nil) {
        self.doubleMin = doubleMin
        self.doubleMax = doubleMax
        self.granularity = granularity
        self.defaultValue = defaultValue
    }
    
    public func apply(to value: Double?) -> Double? {
        guard var value = value else { return nil }
        if let min = doubleMin, value < min {
            value = min
        }
        if let max = doubleMax, value > max {
            value = max
        }
//        if let g = granularity {
//
//        }
        return value
    }
    
    public var log: String {
        let min = doubleMin == nil ? "-∞" : "\(doubleMin!)"
        let max = doubleMax == nil ? "+∞" : "\(doubleMax!)"
        let granularity = granularity == nil ? "" : " ∂: \(granularity!)"
        let defaultValue = defaultValue == nil ? "" : " default: \(defaultValue!)"
        return  "[\(min)..\(max)] \(granularity)\(defaultValue)"
    }
}

// MARK: - CustomStringConvertible Protocol -

extension PXConstraint: CustomStringConvertible {
    
    /// description
    ///
    /// returns the string description formatted as '[-2.0..2.0] ∂ = 1.0 default = 2.0'
    
    public var description: String {
        let _min = doubleMin == nil ? "-∞" : "\(doubleMin!)"
        let _max = doubleMax == nil ? "+∞" : "\(doubleMax!)"
        let _granularity = granularity == nil ? "" : "∂ = \(granularity!)"
        let _default = defaultValue == nil ? "" : "default = \(defaultValue!)"
        return "[\(_min)..\(_max)] \(_granularity) \(_default)"
    }
}
