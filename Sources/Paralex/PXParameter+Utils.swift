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


// MARK: - PXParameter Commons

extension PXParameter {

    public var slug: String {
        identifier.rawValue
    }
    
    /// formattedValue
    ///
    /// Returns the value formatted by a standard Formatter object
    
    public var formattedValue: String {
        if let itemIdentifier = identifier.labelIdentifierForValue?(doubleValue),
           let label = context?.localizedLabel(for: itemIdentifier) {
            return label.symbol ?? label.name
        }
        let formatter: Formatter = formatter ?? type.defaultFormatter
        return formatter.string(for: doubleValue) ?? "\(doubleValue)"
    }
    
    public var granularity: Double? {
        constraint?.granularity
    }

    public var minimum: Double? {
        return constraint?.doubleMin
    }
    
    public var maximum: Double? {
        return constraint?.doubleMax
    }
    
    public var defaultValue: Double? {
        return constraint?.defaultValue
    }
}


/// Access display information

extension PXParameter {
    
    public var role: IdentifierRole {
        return identifier.role
    }

    public var type: PXParameterType {
        return identifier.type
    }

    public var name: String {
        let identifier = identifier.labelIdentifierForValue?(doubleValue) ?? identifier
        return context?.name(for: identifier) ?? identifier.rawValue
    }
    
    public var shortName: String {
        let identifier = identifier.labelIdentifierForValue?(doubleValue) ?? identifier
        return context?.shortName(for: identifier) ?? name
    }
    
    public var abbreviation: String {
        let identifier = identifier.labelIdentifierForValue?(doubleValue) ?? identifier
        return context?.abbreviation(for: identifier) ?? shortName
    }
    
    #if os(macOS)
    public var symbol: String? {
        let identifier = identifier.labelIdentifierForValue?(doubleValue) ?? identifier
        return context?.symbol(for: identifier)
    }
    
    public var symbols: String? {
        let identifier = identifier.labelIdentifierForValue?(doubleValue) ?? identifier
        return context?.symbols(for: identifier)
    }
    #endif
    
    public var symbolName: String? {
        let identifier = identifier.labelIdentifierForValue?(doubleValue) ?? identifier
        return context?.symbolName(for: identifier)
    }
        
    public var symbolNames: [String]? {
        let identifier = identifier.labelIdentifierForValue?(doubleValue) ?? identifier
        return context?.symbolNames(for: identifier)
    }

}

/// Crawl parameters hierarchy
///
public extension PXParameter {
    
    var root: PXGroup? {
        var out: PXGroup? = self.owner
        while let owner = out?.owner {
            out = owner
        }
        return out
    }

    /// path
    ///
    /// Returns node path by concatening indentifiers joined by '.'
    
    var path: String {
        guard let owner = owner else {
            return "\(identifier.rawValue)"
        }
        return "\(owner.path).\(identifier.rawValue)"
    }
    
    
    /// depth
    ///
    /// Returns node depth
    
    var depth: Int {
        if let owner = owner {
            return owner.depth + 1
        }
        return 0
    }
}
