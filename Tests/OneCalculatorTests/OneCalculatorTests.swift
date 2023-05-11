import XCTest
import ArgumentParser
@testable import OneCalculator

final class OneCalculatorTests: XCTestCase {
    
    let sut = OneCalculator()
    func testExample1() throws {
        let result = try! sut.calculate("1/2 * 3&3/4")
        
        XCTAssertEqual(result, "1&7/8")
    }
    
    func testExample2() throws {
        let result = try! sut.calculate("2&3/8 + 9/8")
        
        XCTAssertEqual(result, "3&1/2")
    }
    
    func testExample3() throws {
        let result = try! sut.calculate("1&3/4 - 2")
        
        XCTAssertEqual(result, "-1/4")
    }
    
    func testExample4() throws {
        let result = try! sut.calculate("3 + 2")
        
        XCTAssertEqual(result, "5")
    }
    
    func testExample5() throws {
        let result = try! sut.calculate("3 - 2")
        
        XCTAssertEqual(result, "1")
    }
    
    func testExample6() throws {
        let result = try! sut.calculate("3 / 2")
        
        XCTAssertEqual(result, "1&1/2")
    }
    
    func testExample7() throws {
        let result = try! sut.calculate("3 * 2")
        
        XCTAssertEqual(result, "6")
    }
    
    func testExample8() throws {
        let result = try! sut.calculate("-3 + 2")
        
        XCTAssertEqual(result, "-1")
    }
    
    func testExample9() throws {
        let result = try! sut.calculate("-3 - 2")
        
        XCTAssertEqual(result, "-5")
    }
    
    func testExample10() throws {
        let result = try! sut.calculate("-3 / 2")
        
        XCTAssertEqual(result, "-1&1/2")
    }
    
    func testExample11() throws {
        let result = try! sut.calculate("-3 * 2")
        
        XCTAssertEqual(result, "-6")
    }
    
    func testExample12() throws {
        let result = try! sut.calculate("5 - 5")
        
        XCTAssertEqual(result, "0")
    }
    
    func testExample13() throws {
        let result = try! sut.calculate("5 - 5&1/2")
        
        XCTAssertEqual(result, "-1/2")
    }
    
    func testExample14() throws {
        let result = try! sut.calculate("5&1/2 - 5")
        
        XCTAssertEqual(result, "1/2")
    }
    
    func testExample15() throws {
        let result = try! sut.calculate("1/3 + 2/3")
        
        XCTAssertEqual(result, "1")
    }
    
    func testExample16() throws {
        let result = try! sut.calculate("1/2 + 2/3")
        
        XCTAssertEqual(result, "1&1/6")
    }
    
    func testExample17() throws {
        let result = try! sut.calculate("1/2 / 2/3")
        
        XCTAssertEqual(result, "3/4")
    }
    
    func testExample18() throws {
        let result = try! sut.calculate("-3&1/2 - 1&2/3")
        
        XCTAssertEqual(result, "-5&1/6")
    }
    
    func testExample19() throws {
        let result = try! sut.calculate("100 * 2/3")
        
        XCTAssertEqual(result, "66&2/3")
    }
    
    func testExample20() throws {
        let result = try! sut.calculate("100000 * -1&2/3")
        
        XCTAssertEqual(result, "-166666&2/3")
    }
    
    func testDivisionByZero() throws {
        XCTAssertThrowsError(try sut.calculate("-3 / 0"))
    }
    
    func testInvalidSyntax1() throws {
        XCTAssertThrowsError(try sut.calculate("-3 / 0 + 3"))
    }
    
    func testInvalidSyntax2() throws {
        XCTAssertThrowsError(try sut.calculate("invalid expression"))
    }
    
    func testInvalidNumber1() throws {
        XCTAssertThrowsError(try sut.calculate("-b + 3"))
    }
    
    func testInvalidNumber2() throws {
        XCTAssertThrowsError(try sut.calculate("-3 + 1&y/3"))
    }
    
    func testInvalidSymbol() throws {
        XCTAssertThrowsError(try sut.calculate("-3 x 2"))
    }

}
