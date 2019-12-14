import Utils

/**
 - Opcode 1 adds together numbers read from two positions and stores the result in a third position. The three integers immediately after the opcode tell you these three positions - the first two indicate the positions from which you should read the input values, and the third indicates the position at which the output should be stored.
 - Opcode 2 works exactly like opcode 1, except it multiplies the two inputs instead of adding them. Again, the three integers after the opcode indicate where the inputs and outputs are, not their values.
 - Opcode 3 takes a single integer as input and saves it to the position given by its only parameter. For example, the instruction 3,50 would take an input value and store it at address 50.
 - Opcode 4 outputs the value of its only parameter. For example, the instruction 4,50 would output the value at address 50.
 - Opcode 5 is jump-if-true: if the first parameter is non-zero, it sets the instruction pointer to the value from the second parameter. Otherwise, it does nothing.
 - Opcode 6 is jump-if-false: if the first parameter is zero, it sets the instruction pointer to the value from the second parameter. Otherwise, it does nothing.
 - Opcode 7 is less than: if the first parameter is less than the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
 - Opcode 8 is equals: if the first parameter is equal to the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
 */
public struct Program: Hashable {
  static let PARAMETER_MODE_POSITION = 0
  static let PARAMETER_MODE_IMMEDIATE = 1
  
  var memory: [Int]
  var input: (() -> Int)?
  var output: ((Int) -> Void)?
    
  public func hash(into hasher: inout Hasher) {
    hasher.combine(memory)
  }
  
  init(memory: [Int]) {
    self.memory = memory
  }
  
  public mutating func connectInput(input: @escaping () -> Int) {
    self.input = input
  }
  
  public mutating func connectOutput(output: @escaping (Int) -> Void) {
    self.output = output
  }
  
  public mutating func execute(noun: Int, verb: Int) throws -> Int {
    memory[1] = noun
    memory[2] = verb
    do {
      return try execute()
    } catch {
      throw error
    }
  }

  public mutating func execute() throws -> Int {
    var pointer = 0
    execLoop: while true {
      let (opcode, parameterModes) = try! parseOpcode(encodedOpcode: memory[pointer], pointer: pointer)
      switch opcode {
      case 1, 2:
        let param1 = try! parameterValue(pointer: pointer + 1, mode: parameterModes[0])
        let param2 = try! parameterValue(pointer: pointer + 2, mode: parameterModes[1])
        let resultAddress = memory[pointer + 3]
        if opcode == 1 {
          memory[resultAddress] = param1 + param2
        } else if opcode == 2 {
          memory[resultAddress] = param1 * param2
        }
        pointer += 4
      case 3:
        if let connectedInput = input {
          let inputValue = connectedInput()
          let resultAddress = memory[pointer + 1]
          memory[resultAddress] = inputValue
          pointer += 2
        } else {
          throw ProgramError.inputNotConnected
        }
      case 4:
        if let connectedOutput = output {
          let paramAddress = memory[pointer + 1]
          connectedOutput(memory[paramAddress])
          pointer += 2
        } else {
          throw ProgramError.outputNotConnected
        }
      case 5:
        let param1 = try! parameterValue(pointer: pointer + 1, mode: parameterModes[0])
        if param1 != 0 {
          let param2 = try! parameterValue(pointer: pointer + 2, mode: parameterModes[1])
          pointer = param2
        } else {
          pointer += 3
        }
      case 6:
        let param1 = try! parameterValue(pointer: pointer + 1, mode: parameterModes[0])
        if param1 == 0 {
          let param2 = try! parameterValue(pointer: pointer + 2, mode: parameterModes[1])
          pointer = param2
        } else {
          pointer += 3
        }
      case 7:
        let param1 = try! parameterValue(pointer: pointer + 1, mode: parameterModes[0])
        let param2 = try! parameterValue(pointer: pointer + 2, mode: parameterModes[1])
        let resultAddress = memory[pointer + 3]
        if param1 < param2 {
          memory[resultAddress] = 1
        } else {
          memory[resultAddress] = 0
        }
        pointer += 4
      case 8:
        let param1 = try! parameterValue(pointer: pointer + 1, mode: parameterModes[0])
        let param2 = try! parameterValue(pointer: pointer + 2, mode: parameterModes[1])
        let resultAddress = memory[pointer + 3]
        if param1 == param2 {
          memory[resultAddress] = 1
        } else {
          memory[resultAddress] = 0
        }
        pointer += 4
      case 99:
        break execLoop
      default:
        throw ProgramError.unknownOpcode(opcode: opcode, pointer: pointer)
      }
    }
    return memory[0]
  }
  
  func parseOpcode(encodedOpcode: Int, pointer: Int) throws -> (opcode: Int, parameterModes: [Int]) {
    var parameterModes = [Int]()
    let opcode = encodedOpcode % 100
    switch opcode {
    case 1, 2, 7, 8:
      parameterModes.append(contentsOf: parseParameterModes(encodedOpcode: encodedOpcode, numOfParameters: 3))
    case 3, 4:
      parameterModes.append(contentsOf: parseParameterModes(encodedOpcode: encodedOpcode, numOfParameters: 1))
    case 5, 6:
      parameterModes.append(contentsOf: parseParameterModes(encodedOpcode: encodedOpcode, numOfParameters: 2))
    case 99:
      // Has no parameters
      break
    default:
      throw ProgramError.unknownOpcode(opcode: opcode, pointer: pointer)
    }
    return (opcode, parameterModes)
  }
  
  func parseParameterModes(encodedOpcode: Int, numOfParameters: Int) -> [Int] {
    var parameterModes = [Int]()
    for power in 2...numOfParameters + 1 {
      let nextParameterMode = (encodedOpcode % (10 ^^ (power + 1))) / (10 ^^ power)
      parameterModes.append(nextParameterMode)
    }
    return parameterModes
  }
  
  func parameterValue(pointer: Int, mode: Int) throws -> Int {
    if mode == Program.PARAMETER_MODE_POSITION {
      return memory[memory[pointer]]
    } else if mode == Program.PARAMETER_MODE_IMMEDIATE {
      return memory[pointer]
    } else {
      throw ProgramError.unknownParameterMode(parameterMode: mode, pointer: pointer)
    }
  }
  
  public static func == (lhs: Program, rhs: Program) -> Bool {
    return lhs.memory == rhs.memory
  }
    
  public static func fromFile(path: String) -> Program {
    return Program(memory: readCSVAsInt64(path: path).map { Int($0) })
  }
}

enum ProgramError: Error {
  case unknownOpcode(opcode: Int, pointer: Int)
  case unknownParameterMode(parameterMode: Int, pointer: Int)
  case inputNotConnected
  case outputNotConnected
}
