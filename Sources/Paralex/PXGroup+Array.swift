//
//  File.swift
//  
//
//  Created by Tristan Leblanc on 05/01/2022.
//

import Foundation


// MARK: - Utilities

extension Array where Element == PXGroup {
    
    public subscript (identifier: PXIdentifier) -> PXGroup? {
        return with(identifier: identifier)
    }
    
    public var log: String {
        return map({ $0.log }).joined(separator: "\r")
    }
    
    public func with(identifier: PXIdentifier) -> PXGroup? {
        return (first(where: {$0.identifier == identifier} ))
    }
    
    public func with(string: String) -> PXGroup? {
        return (first(where: {$0.identifier.rawValue == string} ))
    }
    
    public func with(identifier: PXIdentifier, do: @escaping (PXGroup)->Void) {
        guard let parameter = with(identifier: identifier) else { return }
        `do`(parameter)
    }
}
