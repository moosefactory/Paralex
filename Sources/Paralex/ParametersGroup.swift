/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Paralex Framework - v1.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2020 Tristan Leblanc                     */
/*        (oo)             tristan@moosefactory.eu                          */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

//  Created by Tristan Leblanc on 10/12/2021.

import Foundation

public class ParametersGroup: Identified {
    
    public var identifier: Identifier
    
    public var label: LabelInfo?
    
    public var parameters: [Parameter]

    public var subGroups: [ParametersGroup]

    public var log: String {
        var out = [
            "Group \(identifier.log)",
            "Params :"
            ]
        
        out += parameters.map( {$0.log} )
        out += ["SubGroups:"]
        out += subGroups.map( {$0.log} )
        return out.joined(separator: "\r")
    }
    
    public var identifiers: [Identifier] { parameters.map {$0.identifier} }
    
    public subscript(identifier: Identifier) -> AnyParameter? {
        return parameters.first(where: {$0.identifier == identifier} )
    }
    
    // MARK: - Initialisation
    
    public init(identifier: Identifier, parameters: [Parameter], subGroups: [ParametersGroup] = []) {
        self.identifier = identifier
        self.parameters = parameters
        self.subGroups = subGroups
    }
}
