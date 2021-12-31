/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Paralex Framework - v1.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2020 Tristan Leblanc                     */
/*        (oo)             tristan@moosefactory.eu                          */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/

// Created by Tristan Leblanc on 29/04/2020.

import Foundation

public extension Formatter {
    static var intFormatter = IntFormatter()
    static var realFormatter = RealFormatter()
    static var percentFormatter = PercentFormatter()
    static var boolFormatter = BoolFormatter()
    static var onOffFormatter = BoolFormatter(trueString: "On", falseString: "Off")
    static var onOffSymbolFormatter = BoolFormatter(trueString: "􀷄", falseString: "􀷃")
    static var yesNoFormatter = BoolFormatter(trueString: "Yes", falseString: "No")
    static var offsetFormatter = OffsetFormatter()
    static var multiplierFormatter = MultiplierFormatter()
}

public class IntFormatter: NumberFormatter {
    
    public override init() {
        super.init()
        maximumFractionDigits = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


public class RealFormatter: NumberFormatter {
    
    public override init() {
        super.init()
        maximumFractionDigits = 2
        minimumFractionDigits = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


public class VoidFormatter: NumberFormatter {
    
    var voidString: String = "NIL"
    
    override public init() {
        super.init()
    }
    
    public init(voidString: String) {
        self.voidString = voidString
        super.init()
    }
    
    required init?(coder: NSCoder) {
        voidString = String(coder.decodeObject(of: NSString.self, forKey: "voidString") ?? NSString("True"))
        super.init(coder: coder)
    }
    
    public override func string(for obj: Any?) -> String? {
        return voidString
    }
}

public class BoolFormatter: NumberFormatter {
    
    var trueString: String
    var falseString: String
    
    override public init() {
        trueString = "True"
        falseString = "False"
        super.init()
    }
    
    public init(trueString: String, falseString: String) {
        self.trueString = trueString
        self.falseString = falseString
        super.init()
    }
    
    required init?(coder: NSCoder) {
        trueString = String(coder.decodeObject(of: NSString.self, forKey: "trueString") ?? NSString("True"))
        falseString = String(coder.decodeObject(of: NSString.self, forKey: "falseString") ?? NSString("False"))
        super.init(coder: coder)
    }
    
    public override func string(for obj: Any?) -> String? {
        guard let value = obj as? Double else {
            return "-"
        }
        
        return value > 0 ? trueString : falseString
    }
}

public class PercentFormatter: NumberFormatter {
    
    public override init() {
        super.init()
        numberStyle = .percent
        maximumFractionDigits = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class FactorFormatter: NumberFormatter {
    
    public override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func string(for obj: Any?) -> String? {
        guard var value = obj as? Double else {
            return "-"
        }
        
        if value >= 1 {
            positivePrefix = "x"
        } else if value > 0 {
            value = 1 / value
            positivePrefix = "/"
        }
        return super.string(for: ceil(value))
    }
}

public class EnumerationFormatter: NumberFormatter {
    
    public var items: [PXItem]
    
    public init(items: [PXItem]) {
        self.items = items
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func string(for obj: Any?) -> String? {
        guard let value = obj as? Double, !value.isNaN && value.isFinite else {
            return "-"
        }
        let index = Int(value)
        guard index >= 0 && index < items.count else {
            return items.last?.name
        }
        return items[index].name
    }
    
    
    override public var description: String {
        return super.description + "\r\(items)"
    }
    
    override public var debugDescription: String {
        return super.debugDescription + "\r\(items)"
    }
    
}

public class OffsetFormatter: NumberFormatter {
    public override func string(for obj: Any?) -> String? {
        guard let value = obj as? Double, !value.isNaN, value != 0 else {
            return "-"
        }
        positivePrefix = "+"
        return super.string(for: value)
    }
}

public class MultiplierFormatter: NumberFormatter {
    
    public override func string(for obj: Any?) -> String? {
        let valueString = super.string(for: obj) ?? "1"
        return "×\(valueString)"
    }
}

