import Intcode
import Utils

func generateCircuits(variables: Int) -> [[Int]] {
  var circuits = [[Int]]()
  generateCircuits(variables: Array(0..<variables), currentCircuit: [Int](), circuits: &circuits)
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

func executeCircuit(program: Program, circuit: [Int]) -> Int {
  var lastOutput = 0
  for setting in circuit {
    var programCopy = program
    programCopy.connectInput(input: { setting })
    programCopy.connectInput(input: { lastOutput })
    programCopy.connectOutput(output: { lastOutput = $0 })
    try! programCopy.execute()
  }
  return lastOutput
}

public func highestSignal(program: Program) -> (Int, [Int]) {
  var highestSignal = 0
  var highestSignalCircuit = [Int]()
  let circuits = generateCircuits(variables: 5)
  for circuit in circuits {
    let signal = executeCircuit(program: program, circuit: circuit)
    if signal > highestSignal {
      highestSignal = signal
      highestSignalCircuit = circuit
    }
  }
  return (highestSignal, highestSignalCircuit)
}

// Tests
print(highestSignal(program: Program.fromFile(path: "\(currentDir(currentFile: #file))/input-test1.txt")))
print(highestSignal(program: Program.fromFile(path: "\(currentDir(currentFile: #file))/input-test2.txt")))
print(highestSignal(program: Program.fromFile(path: "\(currentDir(currentFile: #file))/input-test3.txt")))

// Part 1
print(highestSignal(program: Program.fromFile(path: "\(currentDir(currentFile: #file))/input-amplification-circuit.txt")))
