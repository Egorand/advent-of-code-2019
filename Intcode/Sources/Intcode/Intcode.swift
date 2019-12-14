import Utils

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
