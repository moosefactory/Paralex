/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Paralex Framework - v1.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2020 Tristan Leblanc                     */
/*        (oo)             tristan@moosefactory.eu                          */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

//  Created by Tristan Leblanc on 22/12/2021.

import Foundation


// MARK: - Double Parameter

/// DoubleParameter
///
/// Wraps an integer into a parameter

public class DoubleParameter: Parameter {
    
    // MARK: Value
    
    public typealias DataType = Double
    
    @Published public var value: DataType {
        didSet {
            self.double = value
        }
    }
    
    public init(_ identifier: Identifier,
                in context: Context,
                type: ParameterType = .double,
                value: DataType? = nil,
                constraint: Constraint? = nil,
                formatter: Formatter = RealFormatter()) {
        self.value = value ?? 0
        super.init(identifier, in: context, type: type, doubleValue: value ?? 0, constraint: constraint)
    }
}

// MARK: - Int Parameter

/// IntParameter
///
/// Wraps an integer into a parameter
///
public class IntParameter: Parameter {
    
    // MARK: Int Value
    
    public typealias DataType = Int

    @Published public var value: DataType {
        didSet {
            self.int = value
        }
    }
    
    public init(_ identifier: Identifier,
                in context: Context,
                value: DataType? = nil,
                type: ParameterType = .int,
                constraint: Constraint? = nil,
                formatter: Formatter = IntFormatter()) {
        self.value = Int(value ?? 0)
        super.init(identifier, in: context, type: type, doubleValue: Double(value ?? 0), constraint: constraint)
    }

}

// MARK: - Bool Parameter

/// BoolParameter
///
/// Wraps a boolean into a parameter

public class BoolParameter: Parameter {
    
    // MARK: Bool Value
    
    public typealias DataType = Bool
    
    public func toggle() {
        value = !value
    }
    
    @Published public var value: DataType {
        didSet {
            self.bool = value
        }
    }

    public init(_ identifier: Identifier,
                in context: Context,
                type: ParameterType = .bool,
                value: DataType? = nil,
                constraint: Constraint? = nil,
                formatter: Formatter = BoolFormatter()) {
        self.value = (value ?? false)
        super.init(identifier, in: context, type: type, doubleValue: (value ?? false) ? 1 : 0, constraint: constraint)
    }

}

// MARK: - Void Parameter

/// VoidParameter
///
/// Wraps a boolean into a parameter

public class VoidParameter: Parameter {
    
    // MARK: Bool Value
    
    public typealias DataType = Int
    
    @Published public var value: DataType

    public init(_ identifier: Identifier,
                in context: Context,
                type: ParameterType = .void,
                formatter: Formatter = BoolFormatter()) {
        self.value = 0
        super.init(identifier, in: context, type: type, doubleValue: 0)
    }

}

