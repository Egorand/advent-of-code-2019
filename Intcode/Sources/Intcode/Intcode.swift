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
      let opcodeAndParameterModes = try! parseOpcode(encodedOpcode: memory[pointer], pointer: pointer)
      let opcode = opcodeAndParameterModes[0]
      switch opcode {
      case 1, 2:
        let param1: Int
        if opcodeAndParameterModes[1] == Program.PARAMETER_MODE_POSITION {
          param1 = memory[memory[pointer + 1]]
        } else if opcodeAndParameterModes[1] == Program.PARAMETER_MODE_IMMEDIATE {
          param1 = memory[pointer + 1]
        } else {
          throw ProgramError.unknownParameterMode(parameterMode: opcodeAndParameterModes[1], pointer: pointer + 1)
        }
        let param2: Int
        if opcodeAndParameterModes[2] == Program.PARAMETER_MODE_POSITION {
          param2 = memory[memory[pointer + 2]]
        } else if opcodeAndParameterModes[2] == Program.PARAMETER_MODE_IMMEDIATE {
          param2 = memory[pointer + 2]
        } else {
          throw ProgramError.unknownParameterMode(parameterMode: opcodeAndParameterModes[2], pointer: pointer + 2)
        }
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
      case 99:
        break execLoop
      default:
        throw ProgramError.unknownOpcode(opcode: opcode, pointer: pointer)
      }
    }
    return memory[0]
  }
  
  func parseOpcode(encodedOpcode: Int, pointer: Int) throws -> [Int] {
    var opcodeAndParameterModes = [Int]()
    let opcode = encodedOpcode % 100
    opcodeAndParameterModes.append(opcode)
    switch opcode {
    case 1, 2:
      opcodeAndParameterModes.append(contentsOf: parseParameterModes(encodedOpcode: encodedOpcode, numOfParameters: 3))
    case 3, 4:
      opcodeAndParameterModes.append(contentsOf: parseParameterModes(encodedOpcode: encodedOpcode, numOfParameters: 1))
    case 99:
      // Has no parameters
      break
    default:
      throw ProgramError.unknownOpcode(opcode: opcode, pointer: pointer)
    }
    return opcodeAndParameterModes
  }
  
  func parseParameterModes(encodedOpcode: Int, numOfParameters: Int) -> [Int] {
    var parameterModes = [Int]()
    for power in 2...numOfParameters + 1 {
      let nextParameterMode = (encodedOpcode % (10 ^^ (power + 1))) / (10 ^^ power)
      parameterModes.append(nextParameterMode)
    }
    return parameterModes
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
