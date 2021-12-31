/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Paralex Framework - v1.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2020 Tristan Leblanc                     */
/*        (oo)             tristan@moosefactory.eu                          */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

//  Created by Tristan Leblanc on 22/12/2021.

import Foundation



// MARK: - Default PXParameter Factory

public extension PXIdentifier {
    
    func makeParameter(in group: PXGroup?) throws -> PXParameter {
        if let group = group, role == .parameter {
            switch self.type {
            case .bool:
                return BoolParameter(self, in: group)
            case .int:
                return IntParameter(self, in: group, constraint: self.constraint)
            case .double:
                return DoubleParameter(self, in: group, constraint: self.constraint)
            default:
                return VoidParameter(self, in: group)
            }
        }
        return PXParameter(self, in: group, constraint: constraint)
    }
}

// MARK: - Double PXParameter

/// DoubleParameter
///
/// Wraps an integer into a parameter

public class DoubleParameter: PXParameter {
    
    // MARK: Value
    
    public typealias DataType = Double
    
    @Published public var value: DataType {
        didSet {
            self.double = value
        }
    }
    
    public init(_ identifier: PXIdentifier,
                in group: PXGroup,
                value: DataType? = nil,
                constraint: PXConstraint? = nil,
                formatter: Formatter = RealFormatter()) {
        self.value = value ?? 0
        super.init(identifier, in: group, doubleValue: value ?? 0, constraint: constraint)
    }
}

// MARK: - Int PXParameter

/// IntParameter
///
/// Wraps an integer into a parameter
///
public class IntParameter: PXParameter {
    
    // MARK: Int Value
    
    public typealias DataType = Int

    @Published public var value: DataType {
        didSet {
            self.int = value
        }
    }
    
    public init(_ identifier: PXIdentifier,
                in group: PXGroup,
                value: DataType? = nil,
                constraint: PXConstraint? = nil,
                formatter: Formatter = IntFormatter()) {
        self.value = Int(value ?? 0)
        super.init(identifier, in: group, doubleValue: Double(value ?? 0), constraint: constraint)
    }

}

// MARK: - Bool PXParameter

/// BoolParameter
///
/// Wraps a boolean into a parameter

public class BoolParameter: PXParameter {
    
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

    public init(_ identifier: PXIdentifier,
                in group: PXGroup,
                type: PXParameterType = .bool,
                value: DataType? = nil,
                constraint: PXConstraint? = nil,
                formatter: Formatter = BoolFormatter()) {
        self.value = (value ?? false)
        super.init(identifier, in: group, doubleValue: (value ?? false) ? 1 : 0, constraint: constraint)
    }

}

// MARK: - Void PXParameter

/// VoidParameter
///
/// Wraps a boolean into a parameter

public class VoidParameter: PXParameter {
    
    // MARK: Bool Value
    
    public typealias DataType = Int
    
    @Published public var value: DataType

    public init(_ identifier: PXIdentifier,
                in group: PXGroup,
                type: PXParameterType = .void,
                formatter: Formatter = BoolFormatter()) {
        self.value = 0
        super.init(identifier, in: group, doubleValue: 0)
    }

}

