/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Paralex Framework - v1.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2020 Tristan Leblanc                     */
/*        (oo)             tristan@moosefactory.eu                          */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

// Context.swift - Created by Tristan Leblanc on 10/12/2021.

import Foundation
#if targetEnvironment(macCatalyst)
import AppKit
#endif

// MARK: - Context -

/// Context
///
/// Context is simple object that manage the localizations

open class Context {
    
    public enum Err: String, Error {
        case notAGroupIdentifier = "notAGroupIdentifier"
        case noIdentifierDefinedForThisGroup = "noIdentifierDefinedForThisGroup"
    }
    
    var localizedNamesFile: String { "\(name.capitalized)ParameterNames" }
    var localizedShortNamesFile: String { "\(name.capitalized)ParameterShortNames" }
    var localizedAbbreviationsFile: String { "\(name.capitalized)ParameterAbbreviations" }
    
    open func name(for identifier: Identifier) -> String {
        localizedLabel(for: identifier).name
    }
    
    open func shortName(for identifier: Identifier) -> String {
        localizedLabel(for: identifier).shortName
    }
    
    open func abbreviation(for identifier: Identifier) -> String {
        localizedLabel(for: identifier).abbreviation
    }

    open func symbols(for identifier: Identifier) -> String? {
        nil
    }

    func symbol(for identifier: Identifier) -> String? {
        localizedLabel(for: identifier).symbol
    }

    
    /// localizationDictionary
    ///
    /// Cache the localization for identifiers as they are requested
    
    var localizationDictionary: [Identifier: LabelInfo]?
    
    public private(set) var name: String
    
    public init(name: String) {
        self.name = name
    }
}

// MARK: - Context -

public extension Context {
    
    func localizedName(for identifier: Identifier) -> String {
        return Bundle.main.localizedString(forKey: identifier.rawValue, value: identifier.rawValue, table: localizedNamesFile)
    }
    
    func localizedShortName(for identifier: Identifier) -> String {
        return Bundle.main.localizedString(forKey: identifier.rawValue, value: identifier.rawValue, table: localizedShortNamesFile)
    }
    
    func localizedAbbreviation(for identifier: Identifier) -> String {
        Bundle.main.localizedString(forKey: identifier.rawValue, value: identifier.rawValue, table: localizedAbbreviationsFile)
    }
    
    func localizedLabel(for identifier: Identifier) -> LabelInfo {
        if let labelInfo = localizationDictionary?[identifier] {
            return labelInfo
        }
        
        if localizationDictionary == nil {
            localizationDictionary = [Identifier: LabelInfo]()
        }
        
        let labelInfo = LabelInfo(slug: identifier.rawValue,
                         name: localizedName(for: identifier),
                         shortName: localizedShortName(for: identifier),
                         abbreviation: localizedAbbreviation(for: identifier),
                         symbols: symbols(for: identifier), symbolIndex: 0)
        
        localizationDictionary![identifier] = labelInfo
        
        return labelInfo
        
    }
    
}
