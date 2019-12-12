import Utils

public struct Program: Hashable {
    var memory: [Int]
    
    init(memory: [Int]) {
        self.memory = memory
    }

    public func execute(noun: Int, verb: Int) -> Int {
        var memory = self.memory
        memory[1] = noun
        memory[2] = verb
        var pointer = 0
        execLoop: while true {
            let opcode = memory[pointer]
            switch opcode {
            case 1, 2:
                let param1 = memory[memory[pointer + 1]]
                let param2 = memory[memory[pointer + 2]]
                let resultAddress = memory[pointer + 3]
                if opcode == 1 {
                    memory[resultAddress] = param1 + param2
                } else if opcode == 2 {
                    memory[resultAddress] = param1 * param2
                }
                pointer += 4
            case 99:
                break execLoop
            default:
                print("Unknown opcode \(opcode) at position \(pointer).")
                break execLoop
            }
        }
        return memory[0]
    }
    
    public static func fromFile(path: String) -> Program {
        return Program(memory: readCSVAsInt64(path: path).map { Int($0) })
    }
}
