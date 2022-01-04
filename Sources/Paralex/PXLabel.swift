//
//  Displayable.swift
//  
//
//  Created by Tristan Leblanc on 28/12/2021.
//

import Foundation


public struct PXLabel: Loggable {
    
    public private(set) var slug: String
    
    /// name
    ///
    /// The displayable localized name.
    /// Name is set by loading an Identifiers table file, or by fetching localization in a strings file
    
    public var name: String
    
    /// shortName
    ///
    /// The displayable localized short name.
    /// Short name is set by loading an Identifiers table file, or by fetching localization in a strings file
    
    public var shortName: String
    
    /// abbreviation
    ///
    /// The displayable localized abbreviation.
    /// Abbreviation is set by loading an Identifiers table file, or by fetching localization in a strings file
    
    public var abbreviation: String
    
    /// symbols
    ///
    /// The displayable symbols.
    /// Symbols string is set by loading an Identifiers table file, or by fetching localization in a strings file
    /// Only one symbol will be displayed, the default index will be 0
    /// This can be used to display different icons for different states
    /// example:
    /// Single icon : "􀊃"
    /// On/Off icon : "􀊃􀊄"
    /// MultipleIcons: "􀆫􀇖􀇆􀇈"
    
    
    public var symbols: String?
    public var symbolNames: [String]?
    
    public var symbolIndex: Int = 0
    
    /// private init
    ///
    /// privacy of init guarantees the slug match with the identifier
    public init(slug: String,
                name: String,
                shortName: String? = nil,
                abbreviation: String? = nil,
                symbols: String? = nil,
                symbolNames: [String]? = nil,
                symbolIndex: Int = 0) {
        self.slug = slug
        self.name = name
        self.shortName = shortName ?? self.name
        self.abbreviation = abbreviation ?? self.shortName
        self.symbols = symbols
        self.symbolNames = symbolNames
        self.symbolIndex = min(symbolIndex, (symbolNames?.count ?? 0) - 1)
    }
    
    
    /// symbol
    ///
    /// Returns the symbol at current symbol index or nil if symbols is not set.
    
    public var symbol: String? {
        guard let symbols = symbols, !symbols.isEmpty, symbolIndex >= 0 else { return nil }
        let index = min(symbolIndex, symbols.count - 1)
        let stringIndex = symbols.index(symbols.startIndex, offsetBy: index)
        return String(symbols[stringIndex])
    }
    
    /// symbolName
    ///
    /// Returns the symbol name at current symbol index or nil if symbols is not set.
    /// Used instead of symbol on iOS, to use in image
    
    public var symbolName: String? {
        guard let symbols = symbolNames, !symbols.isEmpty, symbolIndex >= 0 else { return nil }
        let index = min(symbolIndex, symbols.count - 1)
        return symbols[index]
    }
    
    public var log: String {
        let components = [slug, name, shortName, abbreviation, symbols ?? "", symbol ?? ""]
        return components.joined(separator: "\t")
    }
}
