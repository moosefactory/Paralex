/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Paralex Framework - v1.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2020 Tristan Leblanc                     */
/*        (oo)             tristan@moosefactory.eu                          */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

//  Created by Tristan Leblanc on 23/12/2021.

import Foundation

/// Container
///
/// A paralex container is an object of your own - usually the main object of a Paralex based app - that holds a reference
/// to a paralex context.
///
/// It must conform to the Container protocol.
///
/// This object will act as a parameter factory. It knows what objects to return for a given identifier
///
/// Note that all functions are throwing - We must stay in control.
/// We shall not call them with 'random' identifiers. If an identifier is unknown by your system, it must fail.

public protocol Container {
    
    /// context
    ///
    /// Returns a Context object that will maintain a localization cache.
    /// It is also responsible of returning symbols
    var context: Context { get }
    
    var graph: GroupGraphNode { get }
    
    func constraint(for identifier: Identifier) throws -> Constraint?
        
    /// identifiersInGroup
    ///
    /// returns a tuplet ( identifiers, group identifiers )
    
    func identifiersInGroup(with identifier: Identifier) throws -> ([Identifier], [Identifier])
    
}

extension Container {
    
    
    public func makeParameter(_ identifier: Identifier) throws -> Parameter {
        return Parameter(identifier, in: context)
    }
    
    public func makeParametersGroup(_ identifier: Identifier, in group: Group?) throws -> Group {
        let (identifiers, groupIdentifiers) = try identifiersInGroup(with: identifier)
        let parameters = try identifiers.makeParameters(in: context)
        let subGroups = groupIdentifiers.compactMap { identifier in
            try? makeParametersGroup(identifier, in: group)
        }
        
        return Group(identifier: identifier, parameters: parameters, subGroups: subGroups)
    }

    
    public func makeRootGraphNode(identifier: Identifier) throws -> GroupGraphNode {
        return GroupGraphNode(group: try makeParametersGroup(identifier, in: nil), in: nil)
    }

    
    public func makeGroupGraphNode(identifier: Identifier, in parentgroupNode: GroupGraphNode) throws -> GroupGraphNode {
        return GroupGraphNode(group: try makeParametersGroup(identifier, in: nil), in: parentgroupNode)
    }
    
    public func makeParameterGraphNode(identifier: Identifier, in parentgroupNode: GroupGraphNode) throws -> ParameterGraphNode {
        return ParameterGraphNode(with: try makeParameter(identifier), in: parentgroupNode)
    }
    
}


// MARK: - Search in tree

extension Container {
    
    func groupNode(with path: String) -> GroupGraphNode? {
        let components = path.split(separator: ".")
        var searchNode: GroupGraphNode? = graph
        for component in components {
            let node = searchNode?.node(with: String(component))
            switch node {
            case is GroupGraphNode:
                searchNode = node as? GroupGraphNode
            default:
                return nil
            }
        }
        return searchNode
    }
    
    func parameterNode(with path: String) -> ParameterGraphNode? {
        let components = path.split(separator: ".")
        var searchNode: GroupGraphNode? = graph
        for component in components {
            let node = searchNode?.node(with: String(component))
            switch node {
            case is GroupGraphNode:
                searchNode = node as? GroupGraphNode
            case is ParameterGraphNode:
                return (node as? ParameterGraphNode)
            default:
                return nil
            }
        }
        return nil
    }
}
