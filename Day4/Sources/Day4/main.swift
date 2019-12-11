//- two adjacent digits are the same
//- ltr never decreases
//
//235741
//
//1) normalize:
//
//2
//23
//235
//2357
//2357(4) - is smaller. Is there already a double? No? Inc to match previous.
//23577(1) - is smaller. Is there already a double? Yes? Inc to match previous + 1.
//235778
//
//Attempt 1:
//235778
//235779
//235788
//235789
//235799
//235889
//235899
//235899
//
//Attempt 2:
//235778
//
//235779 235788 235889 236678
//       235789
//                     236679
//                     236689
//                     236778
//                     236779
//                     236788
//                     236789
//                     236799
//                     236889
//                     236899
//                     237789
//                     237889
//                     237899
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
  var lastDoubleDigit = 0
  repeat {
    let smallerDigit = codeRemainder % 10
    let largerDigit = (codeRemainder % 100) / 10
    if smallerDigit < largerDigit {
      return false
    } else if smallerDigit == largerDigit {
      if checkGroups {
        if lastDoubleDigit != largerDigit {
          lastDoubleDigit = largerDigit
        } else {
          lastDoubleDigit = 0
        }
      } else {
        hasDouble = true
      }
    } else if lastDoubleDigit > 0 {
      hasDouble = true
    }
    codeRemainder /= 10
  } while codeRemainder > 10
//  if (hasDouble) {
//    print("valid: \(code)")
//  }
  return hasDouble
}
let input: [Int] = readLines(path: "\(currentDir(currentFile: #file))/input.txt")[0].split(separator: "-").map { Int(String($0))! }
//print(numberOfCodes(range: input[0]...input[1]))
print(numberOfCodes(range: input[0]...input[1], checkGroups: true))

print(isValid(111111, checkGroups: true))
print(isValid(223450, checkGroups: true))
print(isValid(123789, checkGroups: true))
print(isValid(112233, checkGroups: true))
print(isValid(123444, checkGroups: true))
print(isValid(111122, checkGroups: true))
print(isValid(699999, checkGroups: true))
