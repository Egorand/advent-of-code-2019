import Utils

public struct Program: Hashable {
  static let PARAMETER_MODE_POSITION = 0
  static let PARAMETER_MODE_IMMEDIATE = 1
  static let PARAMETER_MODE_RELATIVE = 2
  
  var memory: [Int64:Int64]
  var pointer: Int64 = 0
  var isSuspended: Bool = false
  var relativeBase: Int64 = 0
  
  var inputs = [(() -> Int64)?]()
  var output: ((Int64) -> Void)?
    
  public func hash(into hasher: inout Hasher) {
    hasher.combine(memory)
  }
  
  init(memory: [Int64]) {
    self.memory = Dictionary(uniqueKeysWithValues: zip(memory.indices.map { Int64($0) }, memory))
  }
    
  public func getValueAt(position: Int64) -> Int64 {
    return memory[position, default: 0]
  }
  
  public mutating func connectInput(input: @escaping () -> Int64) {
    inputs.append(input)
    // Resume suspended execution.
    if isSuspended {
      try! execute()
    }
  }
  
  public mutating func connectOutput(output: @escaping (Int64) -> Void) {
    self.output = output
  }
  
  public mutating func execute(noun: Int, verb: Int) throws {
    memory[1] = Int64(noun)
    memory[2] = Int64(verb)
    do {
      try execute()
    } catch {
      throw error
    }
  }

  public mutating func execute() throws {
    isSuspended = false
    execLoop: while true {
      let (opcode, parameterModes) = try! parseOpcode(encodedOpcode: Int(memory[pointer]!), pointer: pointer)
      switch opcode {
      case 1, 2:
        let param1 = try! parameterValue(pointer: pointer + 1, mode: parameterModes[0])
        let param2 = try! parameterValue(pointer: pointer + 2, mode: parameterModes[1])
        let result = try! resultAddress(pointer: pointer + 3, mode: parameterModes[2])
        if opcode == 1 {
          memory[result] = param1 + param2
        } else if opcode == 2 {
          memory[result] = param1 * param2
        }
        pointer += 4
      case 3:
        if inputs.isEmpty {
          // Suspend until an input is connected.
          isSuspended = true
          break execLoop
        }
        if let connectedInput = inputs.removeFirst() {
          let inputValue = connectedInput()
          let result = try! resultAddress(pointer: pointer + 1, mode: parameterModes[0])
          memory[result] = inputValue
          pointer += 2
        }
      case 4:
        if let connectedOutput = output {
          connectedOutput(try! parameterValue(pointer: pointer + 1, mode: parameterModes[0]))
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
        let result = try! resultAddress(pointer: pointer + 3, mode: parameterModes[2])
        if param1 < param2 {
          memory[result] = 1
        } else {
          memory[result] = 0
        }
        pointer += 4
      case 8:
        let param1 = try! parameterValue(pointer: pointer + 1, mode: parameterModes[0])
        let param2 = try! parameterValue(pointer: pointer + 2, mode: parameterModes[1])
        let result = try! resultAddress(pointer: pointer + 3, mode: parameterModes[2])
        if param1 == param2 {
          memory[result] = 1
        } else {
          memory[result] = 0
        }
        pointer += 4
      case 9:
        let param = try! parameterValue(pointer: pointer + 1, mode: parameterModes[0])
        relativeBase += param
        pointer += 2
      case 99:
        pointer = -1
        break execLoop
      default:
        throw ProgramError.unknownOpcode(opcode: opcode, pointer: pointer)
      }
    }
  }
  
  func parseOpcode(encodedOpcode: Int, pointer: Int64) throws -> (opcode: Int, parameterModes: [Int]) {
    var parameterModes = [Int]()
    let opcode = encodedOpcode % 100
    switch opcode {
    case 1, 2, 7, 8:
      parameterModes.append(contentsOf: parseParameterModes(encodedOpcode: encodedOpcode, numOfParameters: 3))
    case 3, 4, 9:
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
  
  func parameterValue(pointer: Int64, mode: Int) throws -> Int64 {
    switch mode {
    case Program.PARAMETER_MODE_POSITION:
      return memory[memory[pointer, default: 0], default: 0]
    case Program.PARAMETER_MODE_IMMEDIATE:
      return memory[pointer, default: 0]
    case Program.PARAMETER_MODE_RELATIVE:
      return relativeBase
    default:
      throw ProgramError.unknownParameterMode(parameterMode: mode, pointer: pointer)
    }
  }
  
  func resultAddress(pointer: Int64, mode: Int) throws -> Int64 {
    switch mode {
    case Program.PARAMETER_MODE_POSITION:
      return memory[pointer, default: 0]
    case Program.PARAMETER_MODE_RELATIVE:
      return relativeBase
    default:
      throw ProgramError.unexpectedAddressMode(addressMode: mode, pointer: pointer)
    }
  }
  
  public static func == (lhs: Program, rhs: Program) -> Bool {
    return lhs.memory == rhs.memory
  }
    
  public static func fromFile(path: String) -> Program {
    return Program(memory: readCSVAsInt64(path: path))
  }
}

enum ProgramError: Error {
  case unknownOpcode(opcode: Int, pointer: Int64)
  case unknownParameterMode(parameterMode: Int, pointer: Int64)
  case unexpectedAddressMode(addressMode: Int, pointer: Int64)
  case inputNotConnected
  case outputNotConnected
}
