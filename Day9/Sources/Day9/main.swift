import Intcode
import Utils

// Part 1
var program = Program.fromFile(path: "\(currentDir(currentFile: #file))/input-sensor-boost.txt")
program.connectInput(input: { 1 })
program.connectOutput(output: { print($0) })
try! program.execute()

// Part 2
program = Program.fromFile(path: "\(currentDir(currentFile: #file))/input-sensor-boost.txt")
program.connectInput(input: { 2 })
program.connectOutput(output: { print($0) })
try! program.execute()
