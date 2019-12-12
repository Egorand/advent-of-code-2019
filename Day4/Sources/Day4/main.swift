import Utils
import Foundation

func numberOfCodes(range: ClosedRange<Int>, checkGroups: Bool = false) -> Int {
  return range
    .filter { code in isValid(code, checkGroups: checkGroups) }
    .count
}

func isValid(_ code: Int, checkGroups: Bool = false) -> Bool {
  var codeRemainder = code
  var hasDouble = false
  var currentSeriesLength = 1
  repeat {
    let smallerDigit = codeRemainder % 10
    let largerDigit = (codeRemainder % 100) / 10
    if smallerDigit < largerDigit {
      return false
    } else if smallerDigit == largerDigit {
      if checkGroups {
        currentSeriesLength += 1
      } else {
        hasDouble = true
      }
    } else {
      if currentSeriesLength == 2 {
        hasDouble = true
      }
      currentSeriesLength = 1
    }
    codeRemainder /= 10
  } while codeRemainder > 10
  return hasDouble || currentSeriesLength == 2
}

let input: [Int] = readLines(path: "\(currentDir(currentFile: #file))/input.txt")[0].split(separator: "-").map { Int(String($0))! }

// Part 1
print(numberOfCodes(range: input[0]...input[1]))

// Part 2
print(numberOfCodes(range: input[0]...input[1], checkGroups: true))
