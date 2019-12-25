import Intcode
import Utils

func generateCircuits(variables: ClosedRange<Int>) -> [[Int]] {
  var circuits = [[Int]]()
  generateCircuits(variables: Array(variables), currentCircuit: [Int](), circuits: &circuits)
  return circuits
}

func generateCircuits(variables: [Int], currentCircuit: [Int], circuits: inout [[Int]]) {
  if variables.isEmpty {
    circuits.append(currentCircuit)
    return
  }
  for variable in variables {
    var modifiedCircuit = Array(currentCircuit)
    modifiedCircuit.append(variable)
    generateCircuits(variables: variables.filter { $0 != variable }, currentCircuit: modifiedCircuit, circuits: &circuits)
  }
}

struct Execution {
  let program: Program
  let mode: Mode
  
  init(program: Program, mode: Mode) {
    self.program = program
    self.mode = mode
  }
  
  enum Mode {
    case oneShot
    case feedbackLoop
  }
}

func executeCircuit(execution: Execution, circuit: [Int]) -> Int {
  var programCopy = execution.program
  switch execution.mode {
  case .oneShot:
    var lastOutput = 0
    for setting in circuit {
      programCopy.connectInput(input: { setting })
      programCopy.connectInput(input: { lastOutput })
      programCopy.connectOutput(output: { lastOutput = $0 })
      try! programCopy.execute()
      programCopy = execution.program
    }
    return lastOutput
  case .feedbackLoop:
    var amplifiers = (1...5).map({ _ in programCopy })
    for (index, setting) in circuit.enumerated() {
      amplifiers[index].connectInput(input: {
        print("Amplifier #\(index) consumes setting \(setting)")
        return setting
      })
      amplifiers[index].connectOutput(output: { signal in
        print("Amplifier #\(index) produces signal \(signal)")
        amplifiers[(index + 1) % amplifiers.count].connectInput(input: {
          print("Amplifier #\(index) consumes signal \(setting)")
          return signal
        })
      })
      if index > 0 {
        print("Executing amplifier #\(index)")
        try! amplifiers[index].execute()
      }
    }
    amplifiers[0].connectInput(input: {
      print("Amplifier #0 consumes 0")
      return 0
    })
    try! amplifiers[0].execute()
    return -1
  }
}

func highestSignal(execution: Execution) -> (Int, [Int]) {
  var highestSignal = 0
  var highestSignalCircuit = [Int]()
  let circuits: [[Int]]
  switch execution.mode {
  case .oneShot:
    circuits = generateCircuits(variables: 0...4)
  case .feedbackLoop:
    circuits = generateCircuits(variables: 5...9)
  }
  for circuit in circuits {
    let signal = executeCircuit(execution: execution, circuit: circuit)
    if signal > highestSignal {
      highestSignal = signal
      highestSignalCircuit = circuit
    }
  }
  return (highestSignal, highestSignalCircuit)
}

// Part 1: Tests
print(highestSignal(execution: Execution(program: Program.fromFile(path: "\(currentDir(currentFile: #file))/input-test1.txt"), mode: .oneShot)))
print(highestSignal(execution: Execution(program: Program.fromFile(path: "\(currentDir(currentFile: #file))/input-test2.txt"), mode: .oneShot)))
print(highestSignal(execution: Execution(program: Program.fromFile(path: "\(currentDir(currentFile: #file))/input-test3.txt"), mode: .oneShot)))

// Part 1
print(highestSignal(execution: Execution(program: Program.fromFile(path: "\(currentDir(currentFile: #file))/input-amplification-circuit.txt"), mode: .oneShot)))

// Part 2: Tests
//print(highestSignal(execution: Execution(program: Program.fromFile(path: "\(currentDir(currentFile: #file))/input-test1-part2.txt"), mode: .feedbackLoop)))
//print(highestSignal(execution: Execution(program: Program.fromFile(path: "\(currentDir(currentFile: #file))/input-test2-part2.txt"), mode: .feedbackLoop)))

print(executeCircuit(execution: Execution(program: Program.fromFile(path: "\(currentDir(currentFile: #file))/input-test1-part2.txt"), mode: .feedbackLoop), circuit: [9,8,7,6,5]))
