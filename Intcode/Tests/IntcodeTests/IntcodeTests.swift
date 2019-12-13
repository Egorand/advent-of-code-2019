import XCTest
@testable import Intcode

final class IntcodeTests: XCTestCase {
  func testAddition() {
    let program = Program(memory: [1,0,0,0,99,2,3])
    XCTAssertEqual(program.execute(noun: 5, verb: 6), 5)
  }
  
  func testMultiplication() {
    let program = Program(memory: [2,0,0,0,99,2,3])
    XCTAssertEqual(program.execute(noun: 5, verb: 6), 6)
  }
  
  func testHalt() {
    let program = Program(memory: [99,2,0,0,0,99,2,3])
    XCTAssertEqual(program.execute(noun: 6, verb: 7), 99)
  }

  static var allTests = [
      ("addition", testAddition),
      ("multiplication", testMultiplication),
      ("halt", testHalt),
  ]
}
