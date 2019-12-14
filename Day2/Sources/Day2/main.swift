import Intcode
import Utils

extension Intcode.Program {
    mutating func findNounAndVerb(targetResult: Int) -> (Int, Int) {
        for noun in 0...99 {
            for verb in 0...99 {
                try! execute(noun: noun, verb: verb)
                let result = getValueAt(position: 0)
                if result == targetResult {
                    return (noun, verb)
                }
            }
        }
        return (-1, -1)
    }
}

var program1 = Program.fromFile(path: "\(currentDir(currentFile: #file))/input-1202-program-alarm.txt")
try! program1.execute(noun: 12, verb: 2)
print(program1.getValueAt(position: 0))

var program2 = Program.fromFile(path: "\(currentDir(currentFile: #file))/input-1202-program-alarm.txt")
print(program2.findNounAndVerb(targetResult: 19690720))
