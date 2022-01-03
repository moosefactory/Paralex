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
/// It has a context, that returns the localizations
/// This object will act as a parameter factory. It knows what objects to return for a given identifier.
///
///
/// Note that all functions are throwing - We must stay in control.
/// We shall not call them with 'random' identifiers. If an identifier is unknown by your system, it must fail.

public protocol PXContainer: Loggable {
    
    /// context
    ///
    /// Returns a PXContext object that will maintain a localization cache.
    /// It is also responsible of returning symbols
    var context: PXContext { get set }
    
    /// factory
    ///
    /// An optional factory that can returns sub identifiers, constraints and groups for given identifiers
    /// This is an option to create parameters

    var factory: PXFactory? { get set }
    
    var root: PXGroup { get set }
    
}

public extension PXContainer {
    var log: String { root.log }
}

// MARK: - Search in tree

extension PXContainer {
    
    public func group(with path: String) -> PXGroup? {
        root.group(with: path)
    }
    
    public func parameter(with path: String) -> PXParameter? {
        root.parameter(with: path)
    }
}
