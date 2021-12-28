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

    var context: Context { get }
    
    func constraint(for identifier: Identifier) throws -> Constraint?
    
    func makeParameter(for identifier: Identifier) throws -> Parameter
    
    /// identifiersInGroup
    ///
    /// returns a tuplet ( identifiers, group identifiers )
    
    func identifiersInGroup(with identifier: Identifier) throws -> ([Identifier], [Identifier])
    
    func makeGroupGraphNode(identifier: Identifier) throws -> GroupGraphNode

}
