import XCTest
@testable import Intcode

final class IntcodeTests: XCTestCase {
  func testAddition() {
    var program = Program(memory: [1,0,0,0,99,2,3])
    XCTAssertEqual(try! program.execute(noun: 5, verb: 6), 5)
  }
  
  func testMultiplication() {
    var program = Program(memory: [2,0,0,0,99,2,3])
    XCTAssertEqual(try! program.execute(noun: 5, verb: 6), 6)
  }
  
  func testHalt() {
    var program = Program(memory: [99,2,0,0,0,99,2,3])
    XCTAssertEqual(try! program.execute(noun: 6, verb: 7), 99)
  }
  
  func testInput() {
    var program = Program(memory: [3,0,99])
    program.connectInput(input: { 1 })
    XCTAssertEqual(try! program.execute(), 1)
  }
  
  func testOutput() {
    var program = Program(memory: [4,0,99])
    program.connectOutput(output: { XCTAssertEqual($0, 4) })
    try! program.execute()
  }
  
  func testPositionMode() {
    var program = Program(memory: [1002,5,3,0,99,33])
    XCTAssertEqual(try! program.execute(), 99)
  }
  
  func testImmediateMode() {
    var program = Program(memory: [1101,100,-3,0,99])
    XCTAssertEqual(try! program.execute(), 97)
  }

  static var allTests = [
      ("addition", testAddition),
      ("multiplication", testMultiplication),
      ("halt", testHalt),
      ("input", testInput),
      ("output", testOutput),
      ("positionMode", testPositionMode),
      ("immediateMode", testImmediateMode),
  ]
}
