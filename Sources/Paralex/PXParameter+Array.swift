//
//  PXParameter+Array.swift
//  Paralex
//
//  Created by Tristan Leblanc on 31/12/2021.
//

import Foundation


// MARK: - Utilities

extension Array where Element == PXParameter {
    
    public subscript (identifier: PXIdentifier) -> PXParameter? {
        return with(identifier: identifier)
    }
    
    public var log: String {
        return map({ $0.log }).joined(separator: "\r")
    }
    
    public func with(identifier: PXIdentifier) -> PXParameter? {
        return first(where: {$0.identifier == identifier} )
    }
    
    public func with(string: String) -> PXParameter? {
        return first(where: {$0.identifier.rawValue == string} )
    }
    
    public func with(identifier: PXIdentifier, do: @escaping (PXParameter)->Void) {
        guard let parameter = with(identifier: identifier) else { return }
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

// MARK: - Array Extras

extension Array where Element == PXIdentifier {
    /// makeParameters
    
    public func makeParameters(in group: PXGroup) throws -> [PXParameter] {
        compactMap {
            try? $0.makeParameter(in: group)
        }
    }
    
}
