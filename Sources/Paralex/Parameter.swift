/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Paralex Framework - v1.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2020 Tristan Leblanc                     */
/*        (oo)             tristan@moosefactory.eu                          */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

//  Created by Tristan Leblanc on 19/12/2021.

import Foundation


// MARK: - Default Parameter Factory

public extension Identifier {
    
    func makeParameter(in context: Context) throws -> Parameter {
        if role == .parameter {
            switch self.type {
            case .bool:
                return BoolParameter(self, in: context)
            case .int:
                return IntParameter(self, in: context, constraint: self.constraint)
            case .double:
                return DoubleParameter(self, in: context, constraint: self.constraint)
            default:
                return VoidParameter(self, in: context)
            }
        }
        return IntParameter(self, in: context, constraint: constraint)
    }
}

// MARK: - Parameter

/// Parameter
///
/// Parameter is an observable object by itself.
///
/// - An objectChange message is sent each time an impacting property is changed
/// - The double value is a published value.

public class Parameter : AnyParameter, ObservableObject {
    
    public var context: Context?
    
    // MARK: Unmutable properties
    
    public let uuid: UUID = UUID()
    
    public let identifier: Identifier
    
    public let type: ParameterType

    // MARK: Mutable Properties
    
    @Published public var doubleValue: Double = 0

    public var constraint: Constraint? { didSet {
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
    
    // MARK: - Initialisation
    
    public init(_ identifier: Identifier,
                in context: Context,
                type: ParameterType = .void,
                doubleValue: Double? = nil,
                constraint: Constraint? = nil,
                formatter: Formatter? = nil) {
        self.identifier = identifier
        // Use passed constraint, or default identifier constraint if nil
        self.constraint = constraint ?? identifier.constraint
        self.formatter = formatter
        self.type = type
        self.context = context
        isActive = true
        innerValue = doubleValue ?? constraint?.defaultValue ?? 0
        self.doubleValue = constraint?.apply(to: innerValue) ?? innerValue
        self.applyConstraint(setDefault: true)
    }
    
    var boolValue: Bool { doubleValue > 0 }
    var intValue: Int { Int(doubleValue) }
    
    public func offsetValue(by offset: Double) {
        var newValue = doubleValue + offset
        applyConstraint(to: &newValue)
        print("Constrained : \(newValue)")
        doubleValue = newValue
    }
}


// MARK: - Utilities

extension Array where Element == Parameter {
    
    public subscript (identifier: Identifier) -> Parameter? {
        return with(identifier: identifier)
    }
    
    public var log: String {
        return map({ $0.log }).joined(separator: "\r")
    }
    
    public func with(identifier: Identifier) -> Parameter? {
        return first(where: {$0.identifier == identifier} )
    }
    
    public func with(string: String) -> Parameter? {
        return first(where: {$0.identifier.rawValue == string} )
    }
    
    public func with(identifier: Identifier, do: @escaping (Parameter)->Void) {
        guard let parameter = first(where: {$0.identifier == identifier}) else { return }
        `do`(parameter)
    }
    
    public func set(doubleValue: Double) {
        forEach { parameter in
            parameter.double = doubleValue
        }
    }

    public var doubleValues: [Double] {
        map { $0.doubleValue }
    }
}
