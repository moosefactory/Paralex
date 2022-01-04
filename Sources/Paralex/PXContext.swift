/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Paralex Framework - v1.0            */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2020 Tristan Leblanc                     */
/*        (oo)             tristan@moosefactory.eu                          */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

// PXContext.swift - Created by Tristan Leblanc on 10/12/2021.

import Foundation
#if targetEnvironment(macCatalyst)
import AppKit
#endif


// MARK: - PXContext -

/// PXContext
///
/// PXContext is simple object that manage the localizations

open class PXContext {
    
    public enum Err: String, Error {
        case notAGroupIdentifier = "notAGroupIdentifier"
        case noIdentifierDefinedForThisGroup = "noIdentifierDefinedForThisGroup"
    }
    
    public private(set) var name: String
    
    /// long names localization strings
    /// by default, file name will be "\(name.capitalized)ParameterNames"
    var localizedNamesFile: String
    /// short names localization strings
    /// by default, file name will be "\(name.capitalized)ParameterShortNames"
    var localizedShortNamesFile: String
    /// abbreviations names localization strings
    /// by default, file name will be "\(name.capitalized)ParameterAbbreviations"
    var localizedAbbreviationsFile: String
    
    /// localizationDictionary
    ///
    /// Cache the localization for identifiers as they are requested
    
    var localizationDictionary: [PXIdentifier: PXLabel]?
    
    
    open func name(for identifier: PXIdentifier) -> String {
        localizedLabel(for: identifier).name
    }
    
    open func shortName(for identifier: PXIdentifier) -> String {
        localizedLabel(for: identifier).shortName
    }
    
    open func abbreviation(for identifier: PXIdentifier) -> String {
        localizedLabel(for: identifier).abbreviation
    }
    
    open func symbols(for identifier: PXIdentifier) -> String? {
        nil
    }
    
#if os(macOS)

    func symbol(for identifier: PXIdentifier) -> String? {
        localizedLabel(for: identifier).symbol
    }
    
#endif

    func symbolName(for identifier: PXIdentifier) -> String? {
        localizedLabel(for: identifier).symbolName
    }
    /// symbolNames
    ///
    /// Returns symbol names to use in `Image`on iOS
    
    open func symbolNames(for identifier: PXIdentifier) -> [String]? {
        nil
    }
    
    public init(name: String) {
        self.name = name
        localizedNamesFile = "\(name.capitalized)ParameterNames"
        localizedShortNamesFile = "\(name.capitalized)ParameterShortNames"
        localizedAbbreviationsFile = "\(name.capitalized)ParameterAbbreviations"
    }
}

// MARK: - Localization -

extension PXContext {
    
    public func localizedLabel(for identifier: PXIdentifier) -> PXLabel {
        if let labelInfo = localizationDictionary?[identifier] {
            return labelInfo
        }
        
        if localizationDictionary == nil {
            localizationDictionary = [PXIdentifier: PXLabel]()
        }
        
        let labelInfo = PXLabel(slug: identifier.rawValue,
                                name: localizedName(for: identifier),
                                shortName: localizedShortName(for: identifier),
                                abbreviation: localizedAbbreviation(for: identifier),
                                symbols: symbols(for: identifier),
                                symbolNames: symbolNames(for: identifier),
                                symbolIndex: 0)
        
        localizationDictionary![identifier] = labelInfo
        
        return labelInfo
        
    }
    
    func localizedName(for identifier: PXIdentifier) -> String {
        return Bundle.main.localizedString(forKey: identifier.rawValue, value: identifier.rawValue, table: localizedNamesFile)
    }
    
    func localizedShortName(for identifier: PXIdentifier) -> String {
        return Bundle.main.localizedString(forKey: identifier.rawValue, value: identifier.rawValue, table: localizedShortNamesFile)
    }
    
    func localizedAbbreviation(for identifier: PXIdentifier) -> String {
        Bundle.main.localizedString(forKey: identifier.rawValue, value: identifier.rawValue, table: localizedAbbreviationsFile)
    }
}

