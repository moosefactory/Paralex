/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Paralex Framework - v1.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2020 Tristan Leblanc                     */
/*        (oo)             tristan@moosefactory.eu                          */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

//  Created by Tristan Leblanc on 15/12/2021.

import Foundation

// MARK: - Identifiable

public protocol Identified {
    var identifier: Identifier { get }
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
