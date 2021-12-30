/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Paralex Framework - v1.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2020 Tristan Leblanc                     */
/*        (oo)             tristan@moosefactory.eu                          */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

//  Created by Tristan Leblanc on 15/12/2021.

import Foundation

#if targetEnvironment(macCatalyst)
import AppKit
#endif

/// GraphNode

public protocol GraphNode: AnyObject, Identified, Loggable {
    var context: Context? { get }
    var name: String? { get }
    var symbols: String? { get }
    var parent: GroupGraphNode? { get set }
}

extension GraphNode {
    public var name: String? {
        context?.name(for: identifier)
    }
    
    public var shortName: String? {
        context?.shortName(for: identifier)
    }
    
    public var abbreviation: String? {
        context?.abbreviation(for: identifier)
    }
    
    public var symbols: String? {
        context?.symbols(for: identifier)
    }
    
    public var symbol: String? {
        context?.symbol(for: identifier)
    }
    
    public var root: GroupGraphNode {
        var out: GraphNode = self
        while let parent = out.parent {
            out = parent
        }
        return out as! GroupGraphNode
    }
}

public extension GraphNode {
    
    /// path
    ///
    /// Returns node path by concatening indentifiers joined by '.'
    
    var path: String {
        if let owner = parent {
            return "\(owner.path).\(identifier.rawValue)"
        }
        return "\(identifier.rawValue)"
    }
    
    
    /// depth
    ///
    /// Returns node depth
    
    var depth: Int {
        if let owner = parent {
            return owner.depth + 1
        }
        return 0
    }
}

public class ParameterGraphNode: GraphNode, ObservableObject {
    public var context: Context? {
        parameter.context
    }
    
    // MARK: Graphnode Protocol
    
    public var parent: GroupGraphNode?
    
    public var parameter: Parameter
    
    public var identifier: Identifier {
        parameter.identifier
    }
    
    // MARK: Loggable Protocol
    
    public var log: String {
        //let pad = String(repeating: " ", count: depth)
        let prefix = parent == nil ? "" : "\(parent!.path)."
        
        return "\(prefix)\(identifier.rawValue)\t\(parameter.log)"
    }
    
    // MARK: Initialisation
    
    init(with parameter: Parameter, in owner: GroupGraphNode) {
        self.parameter = parameter
        // Will always succed, since node is a new one
        try? owner.addChild(self)
    }
}

open class GroupGraphNode: GraphNode {
    
    public var context: Context?
    
    public var symbols: String?
    
    
    // MARK: Graphnode Protocol
    
    public var parent: GroupGraphNode?
    
    public var identifier: Identifier {
        group.identifier
    }
    
    public var group: Group
    public var child: [GraphNode] = []
    
    // MARK: - Access child bu identifier

    public subscript (identifier: Identifier) -> GraphNode? {
        return child.first(where: { $0.identifier == identifier })
    }
    
    public func parameter(with identifier: Identifier) -> Parameter? {
        let parameterNode = child.first(where: { ($0 as? ParameterGraphNode)?.identifier == identifier })
        return (parameterNode as? ParameterGraphNode)?.parameter
    }
    
    public func parameterNode(with identifier: Identifier) -> ParameterGraphNode? {
        let parameterNode = child.first(where: { ($0 as? ParameterGraphNode)?.identifier == identifier })
        return (parameterNode as? ParameterGraphNode)
    }

    // MARK: - Access child by path
    
    public func groupNode(with path: String) -> GroupGraphNode? {
        let components = path.split(separator: ".")
        var searchNode: GroupGraphNode? = self
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
    
    public func parameterNode(with path: String) -> ParameterGraphNode? {
        let components = path.split(separator: ".")
        var searchNode: GroupGraphNode? = self
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

    // MARK: Loggable Protocol
    
    public var log: String {
        var out = "\(identifier.rawValue)\t\(identifier.log)"
        child.forEach {
            out += "\r\($0.log)"
        }
        return out
    }
    
    // MARK: Initialisation
    
    public init(group: Group,
                in parent: GroupGraphNode? = nil,
                name: String? = nil) {
        self.group = group
        self.parent = parent
        var child = [GraphNode]()
        child.append(contentsOf: (group.parameters.map {
            ParameterGraphNode(with: $0, in: self)
        }))
        child.append(contentsOf: (group.subGroups.map {
            GroupGraphNode(group: $0, in: self)
        }))
        self.child = child
    }
    
    public func addChild(_ node: GraphNode) throws {
        guard node.parent == nil else {
            throw Graph.Err.cantAttachAlreadyAttachedNode
        }
        node.parent = self
        child.append(node)
    }
    
    public func node(with slug: String) -> GraphNode? {
        child.first { $0.slug == slug }
    }
    
    public subscript (identifier: Identifier) -> ParameterGraphNode? {
        return child.first(where: { $0.identifier == identifier }) as? ParameterGraphNode
    }
}

/// Graph

public class Graph {
    
    enum Err: Error {
        case cantAttachAlreadyAttachedNode
    }
    
    public var root: GroupGraphNode
    
    init(rootGroup: Group) {
        root = GroupGraphNode(group: rootGroup, in: nil)
    }
}

// MARK: - Loggable Protocol -

extension Graph: Loggable {
    
    public var log: String {
        return root.log
    }
}
