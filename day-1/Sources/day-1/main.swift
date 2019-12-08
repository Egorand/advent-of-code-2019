import Foundation

func readLinesAsInt64(path: String) -> [Int64] {
    let currentFile = URL(fileURLWithPath: #file)
    let currentDir = currentFile.deletingLastPathComponent()
    let file = currentDir.appendingPathComponent(path)
    do {
        let data = try String(contentsOfFile: file.path, encoding: .utf8)
        let lines = data.components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
        return lines.map { Int64($0)! }
    } catch {
        print(error)
    }
    return []
}

func fuelForMass(mass: Int64) -> Int64 {
    return Int64((Double(mass) / 3.0).rounded(.down)) - 2
}

func fuelForMassWithAdded(mass: Int64) -> Int64 {
    let fuel = fuelForMass(mass: mass)
    if fuel <= 0 {
        return 0
    } else {
        return fuel + fuelForMassWithAdded(mass: fuel)
    }
}

func totalFuelRequired() -> Int64 {
    let masses = readLinesAsInt64(path: "input-the-tyranny-of-the-rocket-equation.txt")
    return masses.map { fuelForMass(mass: $0) }.reduce(0, +)
}

func totalFuelWithAddedRequired() -> Int64 {
    let masses = readLinesAsInt64(path: "input-the-tyranny-of-the-rocket-equation-2.txt")
    return masses.map { fuelForMassWithAdded(mass: $0) }.reduce(0, +)
}

print(totalFuelRequired())
print(totalFuelWithAddedRequired())
