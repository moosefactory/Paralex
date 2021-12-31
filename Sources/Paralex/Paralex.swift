/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Paralex Framework - v1.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2020 Tristan Leblanc                     */
/*        (oo)             tristan@moosefactory.eu                          */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

import Foundation
import SwiftUI

/// Paralex
///
/// Paralex Framework - As "Parameters Lexicon"
public struct Paralex {

    static let version = 1.0
    
    public init() {}
}

struct ParalexError: RawRepresentable, Error {
    var rawValue: String
    
    typealias RawValue = String
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }

    static let unregisteredIdentifier = ParalexError(rawValue: "unregisteredIdentifierError")
    static let notAParameter = ParalexError(rawValue: "notAParameter")
    static let cantCreateGroupWithNonGroupIdentifier = ParalexError(rawValue: "cantCreateGroupWithNonGroupIdentifier")
}
