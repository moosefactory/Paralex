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

open class PXGroup: PXParameter {
    
    /// Sub parameters
    public var parameters: [PXParameter]
    
    /// Sub groups
    public var subGroups: [PXGroup] {
        return Array<PXGroup>((parameters.filter({ $0.identifier.role == .group }))
                                .compactMap({$0 as? PXGroup}))
    }
    
    public var subParameters: [PXParameter] {
        let params = parameters.filter({ $0.identifier.role != .group })
        return Array<PXParameter>(params.compactMap({$0 as? PXGroup}))
    }
    
    public var identifiers: [PXIdentifier] { parameters.map {$0.identifier} }
    
    public subscript(identifier: PXIdentifier) -> PXParameter? {
        return parameters.first(where: {$0.identifier == identifier} )
    }
    
    func withParameter(with identifier: PXIdentifier, do closure: @escaping (PXParameter)->Void) {
        guard let parameter = self[identifier] else { return }
        closure(parameter)
    }
    
    open override var context: PXContext? { return _context ?? owner?.context }
    
    var _context: PXContext?
    
    // MARK: - Initialisation
    
    /// init
    ///
    /// Initialise a group with a given identifier
    ///
    /// If passed group is nil, then this group will be a root group
    /// Note that owner can't be nil, so a a group is a root group when owner is self
    ///
    public init(identifier: PXIdentifier, in group: PXGroup?, parameters: [PXParameter] = [], context: PXContext? = nil) throws {
        if identifier.role != .group {
            throw ParalexError.cantCreateGroupWithNonGroupIdentifier
        }
        self._context = context
        self.parameters = parameters
        super.init(identifier, in: group)
    }
    
    // MARK: - Loggable Protocol
    
    public override var log: String {
        let params = subParameters
        let groups = subGroups
        var out = [String]()
        out += params.map( {$0.log} )
        out += groups.map( {$0.log} )
        
        return out.joined(separator: "\r")
    }
    
    
    public var hierarchicalLog: String {
        var params = subParameters
        var groups = subGroups
        var out = [path]
        out += params.map( { "\($0.path)\t\($0.formattedValue)" } )
        out += groups.map( { $0.hierarchicalLog } )
        
        return out.joined(separator: "\r")
    }
    
}


// MARK: - Access child by path

public extension PXGroup {
    
    func group(with identifier: PXIdentifier) -> PXGroup? {
        return parameters[identifier] as? PXGroup
    }
    
    func group(with path: String) -> PXGroup? {
        return parameter(with: path) as? PXGroup
    }
    
    func parameter(with identifier: PXIdentifier) -> PXParameter? {
        return parameters[identifier]
    }
    
    func parameter(with path: String) -> PXParameter? {
        var components = path.split(separator: ".")
        guard components.count > 0 else { return nil }
        let first = String(components.first!)
        if  first == identifier.rawValue {
            components = components.suffix(components.count - 1)
        }
        guard components.count > 0 else { return nil }
        
        var searchNode: PXGroup = self
        
        for component in components {
            let node = searchNode.parameters.with(string: String(component))
            switch node {
            case is PXGroup:
                searchNode = node as! PXGroup
            case is PXParameter:
                return node
            default:
                return nil
            }
        }
        return searchNode
    }
}
