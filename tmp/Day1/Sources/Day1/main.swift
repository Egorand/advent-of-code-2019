import Foundation

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
