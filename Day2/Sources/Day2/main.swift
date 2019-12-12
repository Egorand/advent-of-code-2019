import Intcode
import Utils

extension Intcode.Program {
    func findNounAndVerb(targetResult: Int) -> (Int, Int) {
        for noun in 0...99 {
            for verb in 0...99 {
                let result = execute(noun: noun, verb: verb)
                if result == targetResult {
                    return (noun, verb)
                }
            }
        }
        return (-1, -1)
    }
}

var program1 = Program.fromFile(path: "\(currentDir(currentFile: #file))/input-1202-program-alarm.txt")
print(program1.execute(noun: 12, verb: 2))

var program2 = program1
print(program2.findNounAndVerb(targetResult: 19690720))
