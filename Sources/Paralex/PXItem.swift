/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Paralex Framework - v1.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2020 Tristan Leblanc                     */
/*        (oo)             tristan@moosefactory.eu                          */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

//  Created by Tristan Leblanc on 10/05/2021.

import Foundation

/// Item
///
/// An item is an object that can be used to identify objects in the UI, or enumerated objects in the model.
/// It conforms to the Identifier prototcol, so it can be loaded/localized/displayed as any identifier
///
/// It adds an optionnal reference to any external object

open class PXItem: Identifiable, Hashable {
    
    var context: PXContext?
    
    // Unique string identifier
    public var identifier: PXIdentifier
    
    // Value
    // In some case, an item is attached to a value
    public var value: Int?
    
    public var object: Any?
    
    public var isEnabled: Bool = true
    
    public var name: String { return _name ?? context?.localizedLabel(for: identifier).name ?? identifier.rawValue }
    
    public var _name: String?
    
    public init(identifier: PXIdentifier,
                name: String? = nil,
         in context: PXContext,
         value: Int? = nil,
         object: Any? = nil,
         isEnabled: Bool = true) {
        self.identifier = identifier
        self._name = name
        self.value = value
        self.object = object
        self.isEnabled = isEnabled
        self.context = context
    }
    
    public static func == (lhs: PXItem, rhs: PXItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
}

extension PXItem: Loggable {
    
    public var log: String {
        return "Item \(identifier.log)"
    }
}
