/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Paralex Framework - v1.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2020 Tristan Leblanc                     */
/*        (oo)             tristan@moosefactory.eu                          */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

//  Created by Tristan Leblanc on 15/12/2021.

import Foundation

/// ParameterBase
///
/// The base protocol for parameters and identifiers
///
/// Identifiers and Parameters are both based on this protocol.
///
/// Identifiers use this information to:
///     - Create the parameter
///     - Give relevant informations to the UI, even if a parameter is not set yet
///
/// Parameters are first created from the identifier, and inherits of all properties values
/// They can then be modified for special needs. A common case is the constraint modification.
///
/// ParameterBase constraints can be overiden by parameters.

public protocol ParameterBase: Identifiable {
    
    /// The constraint that will be set to the created parameter
    
    var constraint: PXConstraint? { get }
    
    /// The type of parameter ( bool, int, double )
    
    var type: PXParameterType { get }
}


// MARK: - Identifiable

public protocol Identified {
    var identifier: PXIdentifier { get }
}

public extension Identified {
    
    /// slug
    ///
    /// Direct accessor to the identifier raw value
    
    var slug: String {
        return identifier.rawValue
    }
}

public protocol Loggable {
    var log: String { get }
}

public extension Loggable {
    func printLog() {
        print(log)
    }
}
