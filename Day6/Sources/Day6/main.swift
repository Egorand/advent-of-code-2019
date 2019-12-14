import Foundation
import Utils

struct Space {
  var objects = Set<String>()
  var orbits = [String:String]()
  
  public mutating func addOrbit(object: String, orbits: String) {
    objects.insert(object)
    objects.insert(object)
    self.orbits[object] = orbits
  }
  
  public func countTotalOrbits() -> Int {
    var totalOrbits = 0
    for object in objects {
      var queue = [object]
      while !queue.isEmpty {
        let next = queue.remove(at: 0)
        if let orbits = orbits[next] {
          totalOrbits += 1
          queue.append(orbits)
        }
      }
    }
    return totalOrbits
  }
  
  public func orbitDistance(from: String, to: String) -> Int {
    let startingObject = orbits[from]!
    let targetObject = orbits[to]!
    
    // Build a map of objects reachable from the starting point, along
    // with distances.
    var distancesFromStartingToReachableObjects = [String:Int]()
    var currentDistance = 0
    var nextObject = orbits[startingObject]
    while nextObject != nil {
      currentDistance += 1
      distancesFromStartingToReachableObjects[nextObject!] = currentDistance
      nextObject = orbits[nextObject!]
    }
    
    // Start jumping orbits from the target object until the intersection
    // is found.
    currentDistance = 0
    nextObject = targetObject
    while nextObject != nil {
      if let distanceToStartingObject = distancesFromStartingToReachableObjects[nextObject!] {
        return currentDistance + distanceToStartingObject
      }
      currentDistance += 1
      nextObject = orbits[nextObject!]
    }
    return -1
  }
  
  public static func fromFile(path: String) -> Space {
    var space = Space()
    let lines = readLines(path: path)
    for line in lines {
      let objects = line.components(separatedBy: ")")
      space.addOrbit(object: objects[1], orbits: objects[0])
    }
    return space
  }
}

// Test
var space = Space.fromFile(path: "\(currentDir(currentFile: #file))/input-test.txt")
print(space.countTotalOrbits())

// Test 2
space = Space.fromFile(path: "\(currentDir(currentFile: #file))/input-test2.txt")
print(space.orbitDistance(from: "YOU", to: "SAN"))

space = Space.fromFile(path: "\(currentDir(currentFile: #file))/input-universal-orbit-map.txt")
// Part 1
print(space.countTotalOrbits())
// Part 2
print(space.orbitDistance(from: "YOU", to: "SAN"))
