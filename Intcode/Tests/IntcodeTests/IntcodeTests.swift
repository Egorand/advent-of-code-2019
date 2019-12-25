import XCTest
@testable import Intcode

final class IntcodeTests: XCTestCase {
  func testAddition() {
    var program = Program(memory: [1,0,0,0,99,2,3])
    try! program.execute(noun: 5, verb: 6)
    XCTAssertEqual(program.getValueAt(position: 0), 5)
  }
  
  func testMultiplication() {
    var program = Program(memory: [2,0,0,0,99,2,3])
    try! program.execute(noun: 5, verb: 6)
    XCTAssertEqual(program.getValueAt(position: 0), 6)
  }
  
  func testHalt() {
    var program = Program(memory: [99,2,0,0,0,99,2,3])
    try! program.execute(noun: 6, verb: 7)
    XCTAssertEqual(program.getValueAt(position: 0), 99)
  }
  
  func testInput() {
    var program = Program(memory: [3,0,99])
    program.connectInput(input: { 1 })
    try! program.execute()
    XCTAssertEqual(program.getValueAt(position: 0), 1)
  }
  
  func testMultipleInputs() {
    var program = Program(memory: [3,3,3,-1,99])
    program.connectInput(input: { 0 })
    program.connectInput(input: { 1 })
    try! program.execute()
    XCTAssertEqual(program.getValueAt(position: 0), 1)
  }
  
  func testOutput() {
    var program = Program(memory: [4,0,99])
    program.connectOutput(output: { XCTAssertEqual($0, 4) })
    try! program.execute()
  }
  
  func testPositionMode() {
    var program = Program(memory: [1002,5,3,0,99,33])
    try! program.execute()
    XCTAssertEqual(program.getValueAt(position: 0), 99)
  }
  
  func testImmediateMode() {
    var program = Program(memory: [1101,100,-3,0,99])
    try! program.execute()
    XCTAssertEqual(program.getValueAt(position: 0), 97)
  }
  
  func testJumpIfTrue() {
    var program = Program(memory: [1105,1,3,1101,1,1,0,99])
    try! program.execute()
    XCTAssertEqual(program.getValueAt(position: 0), 2)
    
    // Immediate mode
    let memory = [3,3,1105,-1,9,1101,0,0,12,4,12,99,1]
    executeProgram(memory: memory, input: 0, expectedOutput: 0)
    executeProgram(memory: memory, input: 3, expectedOutput: 1)
  }
  
  func testJumpIfFalse() {
    var program = Program(memory: [1106,0,3,1101,1,1,0,99])
    try! program.execute()
    XCTAssertEqual(program.getValueAt(position: 0), 2)
    
    // Position mode
    let memory = [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9]
    executeProgram(memory: memory, input: 0, expectedOutput: 0)
    executeProgram(memory: memory, input: 3, expectedOutput: 1)
  }
  
  func testLessThan() {
    var program = Program(memory: [1107,1,2,0,99])
    try! program.execute()
    XCTAssertEqual(program.getValueAt(position: 0), 1)
    
    // Position mode
    var memory = [3,9,7,9,10,9,4,9,99,-1,8]
    executeProgram(memory: memory, input: 7, expectedOutput: 1)
    executeProgram(memory: memory, input: 9, expectedOutput: 0)
    
    // Immediate mode
    memory = [3,3,1107,-1,8,3,4,3,99]
    executeProgram(memory: memory, input: 9, expectedOutput: 0)
  }
  
  func testEquals() {
    var program = Program(memory: [1108,2,2,0,99])
    try! program.execute()
    XCTAssertEqual(program.getValueAt(position: 0), 1)
    
    // Position mode
    var memory = [3,9,8,9,10,9,4,9,99,-1,8]
    executeProgram(memory: memory, input: 8, expectedOutput: 1)
    executeProgram(memory: memory, input: 9, expectedOutput: 0)
    
    // Immediate mode
    memory = [3,3,1108,-1,8,3,4,3,99]
    executeProgram(memory: memory, input: 8, expectedOutput: 1)
    executeProgram(memory: memory, input: 9, expectedOutput: 0)
  }
  
  func testJumpsAndComparisons() {
    let memory = [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
    1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
    999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99]
    
    executeProgram(memory: memory, input: 6, expectedOutput: 999)
    executeProgram(memory: memory, input: 8, expectedOutput: 1000)
    executeProgram(memory: memory, input: 71, expectedOutput: 1001)
  }
  
  func testResumeProgram() {
    var program = Program(memory: [3,1,4,1,99])
    program.connectOutput(output: assertOutput(isEqualTo: 5))
    try! program.execute() // Will suspend since input is not connected.
    program.connectInput(input: { 5 })
  }
  
  func testRelativeBase() {
    let memory = [9,3,204,55,99]
    executeProgram(memory: memory, input: 0, expectedOutput: 55)
  }
  
  func executeProgram(memory: [Int], input: Int, expectedOutput: Int) {
    var program = Program(memory: memory)
    program.connectInput(input: { input })
    program.connectOutput(output: assertOutput(isEqualTo: expectedOutput))
    try! program.execute()
  }
  
  func assertOutput(isEqualTo: Int) -> (Int) -> Void {
    return { XCTAssertEqual($0, isEqualTo) }
  }

  static var allTests = [
      ("addition", testAddition),
      ("multiplication", testMultiplication),
      ("halt", testHalt),
      ("input", testInput),
      ("multipleInputs", testMultipleInputs),
      ("output", testOutput),
      ("positionMode", testPositionMode),
      ("immediateMode", testImmediateMode),
      ("jumpIfTrue", testJumpIfTrue),
      ("jumpIfFalse", testJumpIfFalse),
      ("lessThan", testLessThan),
      ("equals", testEquals),
      ("jumpsAndComparisons", testJumpsAndComparisons),
      ("resumeProgram", testResumeProgram),
      ("relativeBase", testRelativeBase),
  ]
}
