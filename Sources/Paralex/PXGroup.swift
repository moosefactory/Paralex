/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Paralex Framework - v1.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2020 Tristan Leblanc                     */
/*        (oo)             tristan@moosefactory.eu                          */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

//  Created by Tristan Leblanc on 10/12/2021.

import Foundation

/// PXGroup
///
/// PXGroup is a subclass of PXParameter
///
/// Role is always `.group`, but type can be any. The common case is `.void`, but
/// a group can be a boolean to be used to enable/disable a group,
/// or even a double to set a scale to subparameters for example.
///
/// The developper is free to use this feature as he feels.
///

public class PXGroup: PXParameter {
    
    /// Sub parameters
    public var parameters: [PXParameter]
    
    /// Sub groups
    public var subGroups: [PXGroup] {
        return (parameters.filter({ $0.identifier.role == .group })) as! [PXGroup]
    }

    public var subParameters: [PXParameter] {
        return (parameters.filter({ $0.identifier.role != .group }))
    }

    public var identifiers: [PXIdentifier] { parameters.map {$0.identifier} }
    
    public subscript(identifier: PXIdentifier) -> PXParameter? {
        return parameters.first(where: {$0.identifier == identifier} )
    }
    
    func withParameter(with identifier: PXIdentifier, do closure: @escaping (PXParameter)->Void) {
        guard let parameter = self[identifier] else { return }
        closure(parameter)
    }
    
    // MARK: - Initialisation
    
    /// init
    ///
    /// Initialise a group with a given identifier
    ///
    /// If passed group is nil, then this group will be a root group
    /// Note that owner can't be nil, so a a group is a root group when owner is self
    ///
    public init(identifier: PXIdentifier, in group: PXGroup?, parameters: [PXParameter]) throws {
        if identifier.role != .group {
            throw ParalexError.cantCreateGroupWithNonGroupIdentifier
        }
        self.parameters = parameters
        super.init(identifier, in: group)
    }
    
    // MARK: - Loggable Protocol
   
    public override var log: String {
        var out = [
            "PXGroup \(identifier.log)",
            "Params :"
        ]
        
        out += parameters.map( {$0.log} )
        out += ["SubGroups:"]
        out += subGroups.map( {$0.log} )
        return out.joined(separator: "\r")
    }

}


// MARK: - Access child by path

public extension PXGroup {
    
    func parameter(with path: String) -> PXParameter? {
        let components = path.split(separator: ".")
        
        var searchNode: PXGroup = self
        
        for component in components {
            let node = searchNode.parameters.with(string: String(component))
            switch node {
            case is PXGroup:
                searchNode = node as! PXGroup
            default:
                return nil
            }
        }
        return searchNode
    }
}
