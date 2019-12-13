import Intcode
import Utils

// Part 1
var program = Program.fromFile(path: "\(currentDir(currentFile: #file))/input-sunny-with-a-chance-of-asteroids.txt")
program.connectInput(input: { 1 })
program.connectOutput(output: { print($0) })
try! program.execute()
