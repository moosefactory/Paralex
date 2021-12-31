//
//  PXIdentifier+ParameterFactory.swift
//  Paralex
//
//  Created by Tristan Leblanc on 30/12/2021.
//

import Foundation

// MARK: - Parameters Factory

public extension PXIdentifier {
    
    /// command
    ///
    /// Creates a command identifier
    /// If no name is passed, the raw value is used
    
    static func command(_ identifier: String) -> PXIdentifier {
        PXIdentifier(rawValue: identifier, role: .command, type: .void)
    }
    
    /// parameter
    ///
    /// Creates a parameter identifier
    /// If no name is passed, the identifier raw value is used
    
    static func parameter(_ identifier: String, type: PXParameterType, constraint: PXConstraint? = nil) -> PXIdentifier {
        PXIdentifier(rawValue: identifier, role: .parameter, type: type, constraint: constraint)
    }
    
    
    static func bool(_ identifier: String) -> PXIdentifier {
        PXIdentifier(rawValue: identifier, role: .parameter, type: .bool)
    }
    
    static func int(_ identifier: String, constraint: PXConstraint?) -> PXIdentifier {
        PXIdentifier(rawValue: identifier, role: .parameter, type: .int, constraint: constraint)
    }
    
    static func unsignedInt(_ identifier: String, defaultValue: Int = 0) -> PXIdentifier {
        let constraint = PXConstraint(doubleMin: 0, granularity: 1, defaultValue: Double(defaultValue))
        return PXIdentifier(rawValue: identifier, role: .parameter, type: .int, constraint: constraint)
    }
    
    static func int(_ identifier: String, defaultValue: Int = 0) -> PXIdentifier {
        let constraint = PXConstraint(granularity: 1, defaultValue: Double(defaultValue))
        return PXIdentifier(rawValue: identifier, role: .parameter, type: .int, constraint: constraint)
    }

    static func int4(_ identifier: String, defaultValue: Int = 0) -> PXIdentifier {
        let defaultValue = max(min(15, defaultValue), 0)
        let constraint = PXConstraint(doubleMin: 0, doubleMax: 15, granularity: 1, defaultValue: Double(defaultValue))
        return PXIdentifier(rawValue: identifier, role: .parameter, type: .int, constraint: constraint)
    }
    
    static func int7(_ identifier: String, defaultValue: Int = 0) -> PXIdentifier {
        let defaultValue = max(min(127, defaultValue), 0)
        let constraint = PXConstraint(doubleMin: 0, doubleMax: 127, granularity: 1, defaultValue: Double(defaultValue))
        return PXIdentifier(rawValue: identifier, role: .parameter, type: .int, constraint: constraint)
    }
    
    static func unsignedInt7(_ identifier: String, defaultValue: Int = 0) -> PXIdentifier {
        let defaultValue = max(min(64, defaultValue), -64)
        let constraint = PXConstraint(doubleMin: -63, doubleMax: 64, granularity: 1, defaultValue: Double(defaultValue))
        return PXIdentifier(rawValue: identifier, role: .parameter, type: .int, constraint: constraint)
    }

    static func int8(_ identifier: String, defaultValue: Int = 0) -> PXIdentifier {
        let defaultValue = max(min(255, defaultValue), 0)
        let constraint = PXConstraint(doubleMin: 0, doubleMax: 255, granularity: 1, defaultValue: Double(defaultValue))
        return PXIdentifier(rawValue: identifier, role: .parameter, type: .int, constraint: constraint)
    }

    static func unsignedInt8(_ identifier: String, defaultValue: Int = 0) -> PXIdentifier {
        let defaultValue = max(min(128, defaultValue), -127)
        let constraint = PXConstraint(doubleMin: -127, doubleMax: 128, granularity: 1, defaultValue: Double(defaultValue))
        return PXIdentifier(rawValue: identifier, role: .parameter, type: .int, constraint: constraint)
    }

    static func int16(_ identifier: String, defaultValue: Int = 0) -> PXIdentifier {
        let defaultValue = max(min(65535, defaultValue),0)
        let constraint = PXConstraint(doubleMin: 0, doubleMax: 65535, granularity: 1, defaultValue: Double(defaultValue))
        return PXIdentifier(rawValue: identifier, role: .parameter, type: .int, constraint: constraint)
    }

    static func percent(_ identifier: String,
                                 granularity: Double = 0.01,
                                 positive: Bool = true,
                                 defaultValue: Int? = nil) -> PXIdentifier {
        let defaultValue = defaultValue == nil ? nil : max(min(1, defaultValue ?? 0),0)
        let constraint = PXConstraint(doubleMin: positive ? 0 : -1, doubleMax: 1, granularity: granularity, defaultValue: defaultValue == nil ? nil : Double(defaultValue!))
        return PXIdentifier(rawValue: identifier, role: .parameter, type: .double, constraint: constraint)
    }

    
    static func unsignedPercent(_ identifier: String,
                                 granularity: Double = 0.01,
                                 defaultValue: Int? = nil) -> PXIdentifier {
        percent(identifier, granularity: granularity, positive: false, defaultValue: defaultValue ?? 0)
    }

    static func double(_ identifier: String, constraint: PXConstraint) -> PXIdentifier {
        PXIdentifier(rawValue: identifier, role: .parameter, type: .double, constraint: constraint)
    }

    static func double(_ identifier: String, defaultValue: Double? = 0) -> PXIdentifier {
        let constraint = PXConstraint(defaultValue: defaultValue)
        return double(identifier, constraint: constraint)
    }
    
    /// tableParameter
    ///
    /// creates an int parameter that represents an index in a table.
    /// for now - there is strictly no responsibility at this level for items definition.
    /// This simply ensure the created identifier has the right size of items.
    
    static func table(_ identifier: String, array: Array<Any>, defaultIndex: Int = 0) -> PXIdentifier {
        let maxValue = Double(array.count)
        let defaultValue = max(min(maxValue, Double(defaultIndex)),0)
        let constraint = PXConstraint(doubleMin: 0, doubleMax: maxValue, granularity: 1, defaultValue: Double(defaultValue))
        return PXIdentifier(rawValue: identifier, role: .parameter, type: .int, constraint: constraint)
    }

    /// label
    ///
    /// If no name is passed, the identifier raw value is used
    
    static func label(_ identifier: String, constraint: PXConstraint? = nil) -> PXIdentifier {
        PXIdentifier(rawValue: identifier, role: .label, type: .void, constraint: constraint)
    }
    
    /// group
    ///
    /// Creates a group identifier
    /// If no name is passed, the raw value is used
    
    static func group(_ identifier: String, constraint: PXConstraint? = nil) -> PXIdentifier {
        PXIdentifier(rawValue: identifier, role: .group, type: .bool, constraint: constraint)
    }
    
}