import XCTest
@testable import Paralex

func printSection(_ string: String) {
    print("\r------- \(string) ------\r\r")
}

func testSection(_ string: String, _ closure: @escaping ( () throws -> Void)) rethrows {
    printSection(string)
    try closure()
    print("\r-----------------------\r\r")
}

final class ParalexTests: XCTestCase {
    func testExample() throws {
        let myLabel = Bundle.main.localizedString(forKey: "myLabel", value: "myLabel", table: "ParameterNames.strings")
        print(myLabel)
        
        print(NSLocalizedString("myLabel", tableName: "ParameterNames.strings", bundle: .main, value: "myLabel", comment: "comment"))
        
        print(NSLocalizedString("myLabel", tableName: "ParameterNames", bundle: .main, value: "myLabel", comment: "comment"))
    }
}
