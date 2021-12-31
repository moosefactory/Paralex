//
//  PXFactory.swift
//  Paralex
//
//  Created by Tristan Leblanc on 31/12/2021.
//

import Foundation


public protocol PXFactory {
    
    func makeGroup(with identifier: PXIdentifier, in group: PXGroup?) throws -> PXGroup

    func identifiersInGroup(with identifier: PXIdentifier) throws -> [PXIdentifier]
    
    func constraint(for identifier: PXIdentifier) throws -> PXConstraint?
    
}
