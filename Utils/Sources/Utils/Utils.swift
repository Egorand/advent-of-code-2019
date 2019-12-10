import Foundation

public func readLines(path: String) -> [String] {
  return readFileWithSeparator(path: path, separator: .newlines)
}

public func readLinesAsInt64(path: String) -> [Int64] {
    return readFileWithSeparatorAsInt64(path: path, separator: .newlines)
}

public func readCSVAsInt64(path: String) -> [Int64] {
    return readFileWithSeparatorAsInt64(path: path, separator: CharacterSet(charactersIn: ","))
}

func readFileWithSeparatorAsInt64(path: String, separator: CharacterSet) -> [Int64] {
    return readFileWithSeparator(path: path, separator: separator).map { (value: String) in
        if let int = Int64(value) {
            return int
        } else {
            print("Can't parse \(value)")
            return -1
        }
    }
}

func readFileWithSeparator(path: String, separator: CharacterSet) -> [String] {
    do {
        let data = try String(contentsOfFile: path, encoding: .utf8)
        let values = data.components(separatedBy: separator)
            .filter { !$0.isEmpty }
        return values
    } catch {
        print(error)
    }
    return []
}

public func currentDir(currentFile: String) -> String {
    let currentFile = URL(fileURLWithPath: currentFile)
    let currentDir = currentFile.deletingLastPathComponent()
    return currentDir.path
}
