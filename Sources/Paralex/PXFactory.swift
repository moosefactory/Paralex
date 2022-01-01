//
//  PXFactory.swift
//  Paralex
//
//  Created by Tristan Leblanc on 31/12/2021.
//

import Foundation


public protocol PXFactory {

    func identifiersInGroup(with identifier: PXIdentifier) throws -> [PXIdentifier]
    
    func constraint(for identifier: PXIdentifier) throws -> PXConstraint?
    
}

public extension PXFactory {
    
    func makeRoot(with identifier: PXIdentifier) throws -> PXGroup {
        try makeGroup(with: identifier, in: nil)
    }
    
    func makeGroup(with identifier: PXIdentifier, in group: PXGroup? = nil) throws -> PXGroup {
        let identifiers = try identifiersInGroup(with: identifier)
        let newGroup = try PXGroup(identifier: identifier, in: group, parameters: [])
        identifiers.forEach { _identifier in
            if _identifier.isGroup {
                _ = try? makeGroup(with: _identifier, in: newGroup )
            }
            else {
                _ = try? _identifier.makeParameter(in: newGroup)
            }
        }
        return newGroup
    }

}
