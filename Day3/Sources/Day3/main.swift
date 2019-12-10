import Utils

struct Location: Hashable, Equatable {
  let (x, y): (Int, Int)
  
  init(_ x: Int, _ y: Int) {
    self.x = x
    self.y = y
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.x)
    hasher.combine(self.y)
  }
  
  static func == (lhs: Location, rhs: Location) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
  }
}

func getLocationsForPath(path: String) -> Dictionary<Location, Int> {
  let segments = path.split(separator: ",")
  var lastLocation = Location(0, 0)
  var totalSteps = 0
  var locations = Dictionary<Location, Int>()
  for segment in segments {
    let direction = segment[segment.startIndex]
    let steps = Int(segment[segment.index(segment.startIndex, offsetBy: 1)...])!
    for _ in 0..<steps {
      let nextLocation: Location
      switch direction {
      case "D":
        nextLocation = Location(lastLocation.x, lastLocation.y - 1)
      case "L":
        nextLocation = Location(lastLocation.x - 1, lastLocation.y)
      case "R":
        nextLocation = Location(lastLocation.x + 1, lastLocation.y)
      case "U":
        nextLocation = Location(lastLocation.x, lastLocation.y + 1)
      default:
        print("Unknown direction \(direction) in segment \(segment).")
        return [:]
      }
      totalSteps += 1
      if locations[nextLocation] == nil {
        locations[nextLocation] = totalSteps
      }
      lastLocation = nextLocation
    }
  }
  return locations
}

func manhattanDistance(location: Location) -> Int {
  return abs(location.x) + abs(location.y)
}

func findMinManhattanDistance(firstPath: Set<Location>, secondPath: Set<Location>) -> Int {
  var minDistance = Int.max
  for location in secondPath {
    if firstPath.contains(location) {
      let distance = manhattanDistance(location: location)
      if distance < minDistance {
        minDistance = distance
      }
    }
  }
  return minDistance
}

func findStepsToClosestIntersection(firstPath: Dictionary<Location, Int>, secondPath: Dictionary<Location, Int>) -> Int {
  var minStepsToIntersection = Int.max
  for (location, stepsToReach) in secondPath {
    if firstPath.keys.contains(location) {
      let combinedSteps = stepsToReach + firstPath[location]!
      if combinedSteps < minStepsToIntersection {
        minStepsToIntersection = combinedSteps
      }
    }
  }
  return minStepsToIntersection
}

let lines = readLines(path: "\(currentDir(currentFile: #file))/input-crossed-wires.txt")
let firstPathLocations = getLocationsForPath(path: lines[0])
let secondPathLocations = getLocationsForPath(path: lines[1])

// Part 1
print(findMinManhattanDistance(firstPath: Set(firstPathLocations.keys), secondPath: Set(secondPathLocations.keys)))

// Part 2
print(findStepsToClosestIntersection(firstPath: firstPathLocations, secondPath: secondPathLocations))
