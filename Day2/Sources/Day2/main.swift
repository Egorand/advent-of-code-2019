import Utils

struct Program {
    var instructions: [Int]
    
    init(instructions: [Int]) {
        self.instructions = instructions
    }
    
    mutating func prepare(noun: Int, verb: Int) {
        instructions[1] = noun
        instructions[2] = verb
    }

    mutating func execute() {
        var pointer = 0
        execLoop: while true {
            let opcode = instructions[pointer]
            switch opcode {
            case 1, 2:
                let param1 = instructions[instructions[pointer + 1]]
                let param2 = instructions[instructions[pointer + 2]]
                let resultIndex = instructions[pointer + 3]
                if opcode == 1 {
                    instructions[resultIndex] = param1 + param2
                } else if opcode == 2 {
                    instructions[resultIndex] = param1 * param2
                }
                pointer += 4
            case 99:
                break execLoop
            default:
                print("Unknown opcode \(opcode) at position \(pointer).")
                break execLoop
            }
        }
        print(instructions)
    }
    
    static func fromFile(path: String) -> Program {
        return Program(instructions: readCSVAsInt64(path: path).map { Int($0) })
    }
}

var program = Program.fromFile(path: "\(currentDir(currentFile: #file))/input-1202-program-alarm.txt")
program.prepare(noun: 12, verb: 2)
program.execute()
