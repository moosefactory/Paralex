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
///
public class Item: Identifiable {
    
    var context: Context?
    
    // Unique string identifier
    var identifier: Identifier
    
    // Value
    // In some case, an item is attached to a value ( like midi control number )
    let value: Int?
    
    let data: Any?
    
    var isEnabled: Bool = true
    
    var name: String { return context?.localizedLabel(for: identifier).name ?? identifier.rawValue }
    
    init(identifier: Identifier,
         in context: Context,
         value: Int? = nil, data: Any? = nil,
         isEnabled: Bool = true) {
        self.identifier = identifier
        self.value = value
        self.data = data
        self.isEnabled = isEnabled
        self.context = context
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
}

extension Item: Loggable {
    
    public var log: String {
        return "Item \(identifier.log)"
    }
}
