print("Hello, world!")

// let vs var
var myVariable = 42
myVariable = 50
let myConstant = 42

// Implicit vs explicit types
let implicitInteger = 70
let implicitDouble = 70.0
let explicitDouble: Double = 70

let explicitFloat: Float = 4

// Type conversion
// Types are never converted implicitly!
let label = "The width is "
let width = 94
let widthLabel = label + String(width)

// String interpolation
let apples = 3
let oranges = 5
let appleSummary = "I have \(apples) apples."
let fruitSummary = "I have \(apples + oranges) pieces of fruit."

let rectWidth: Float = 2.6
let rectHeight: Float = 3.2
let rectSummary = "Rect area is \(rectWidth + rectHeight)."

let name = "Sam"
let greeting = "Hello, \(name)!"

// Multiline strings
// Extra indentation is trimmed if it matches closing """
let quotation = """
I said "I have \(apples) apples."
And then I said "I have \(apples + oranges) pieces of
       fruit."
"""

// Arrays
var shoppingList = ["catfish", "water", "tulips"]
shoppingList[1] = "bottle of water"
print(shoppingList)

// Maps (dictionaries)
var occupations = [
    "Malcolm": "Captain",
    "Kaylee": "Mechanic",
]
occupations["Jayne"] = "Public Relations"
print(occupations)

// Arrays grow automatically
shoppingList.append("blue paint")
print(shoppingList)

// Empty arrays and maps
let emptyArray = [String]()
let emptyDictionary = [String: Float]()

let unknownArrayType: [String]
unknownArrayType = []
let unknownMapType: [String: Float]
unknownMapType = [:]

// Control flow
let individualScores = [75, 43, 103, 87, 12]
var teamScore = 0
// Parens around condition are optional, braces around body are required
for score in individualScores {
    // Conditional has to be a boolean
    if score > 50 {
        teamScore += 3
    } else {
        teamScore += 1
    }
}
print(teamScore)

// Optionals
var optionalString: String? = "Hello"
print(optionalString == nil)

var optionalName: String? = nil
var greeting2 = "Hello!"
// nil-check and cast to String
if let name = optionalName {
    greeting2 = "Hello, \(name)"
} else {
    greeting2 = "Hello, stranger!"
}

let nickName: String? = nil
let fullName: String = "John Appleseed"
let informalGreeting = "Hi \(nickName ?? fullName)"

// Switch
let vegetable = "red pepper"
// Must be exhaustive - can't remove default!
// Also, no fallthroughs, break is not necessary
switch vegetable {
case "celery":
    print("Add some raisins and make ants on a log.")
case "cucumber", "watercress":
    print("That would make a good tea sandwich.")
case let x where x.hasSuffix("pepper"):
    print("Is it a spicy \(x)?")
default:
    print("Everything tastes good in soup.")
}

let interestingNumbers = [
    "Prime": [2, 3, 5, 7, 11, 13],
    "Fibonacci": [1, 1, 2, 3, 5, 8],
    "Square": [1, 4, 9, 16, 25],
]
var largest = 0
var largestKindOptional: String? = nil
for (kind, numbers) in interestingNumbers {
    for number in numbers {
        if number > largest {
            largest = number
            largestKindOptional = kind
        }
    }
}
if let largestKind = largestKindOptional {
    print("Largest number is \(largest) of kind \(largestKind)")
} else {
    print("No numbers!")
}

// while
var n = 2
while n < 100 {
    n *= 2
}
print(n)

var m = 2
repeat {
    m *= 2
} while m < 100
print(m)

// Index in a loop
var total = 0
// .. for inclusive range, ..< for exclusive
for i in 0..<4 {
    total += i
}
print(total)

// Functions
func greet(person: String, lunchSpecial: String) -> String {
    return "Hello \(person)! Today's lunch special is \(lunchSpecial)."
}
// Argument labels are required!
greet(person: "Bob", lunchSpecial: "Grilled Cheese")

// Can use different values for argument names & labels, _ for no label
func greet(_ person: String, on day: String) -> String {
    return "Hello \(person), today is \(day)."
}
greet("John", on: "Wednesday")

// Tuples
func calculateStatistics(scores: [Int]) -> (min: Int, max: Int, sum: Int) {
    var min = scores[0]
    var max = scores[0]
    var sum = 0
    
    for score in scores {
        if score > max {
            max = score
        } else if score < min {
            min = score
        }
        sum += score
    }
    
    return (min, max, sum)
}
let statistics = calculateStatistics(scores: [5, 3, 100, 3, 9])
// Can reference tuple element by name or index
print(statistics.sum)
print(statistics.2)

// Nested functions
func returnFifteen() -> Int {
    var y = 10
    func add() {
        y += 5
    }
    add()
    return y
}
returnFifteen()

// Function references
func makeIncrementer() -> ((Int) -> Int) {
    func addOne(number: Int) -> Int {
        return 1 + number
    }
    return addOne
}
var increment = makeIncrementer()
increment(7)

func hasAnyMatches(list: [Int], condition: (Int) -> Bool) -> Bool {
    for item in list {
        if condition(item) {
            return true
        }
    }
    return false
}
func lessThanTen(number: Int) -> Bool {
    return number < 10
}
var numbers = [20, 19, 7, 12]
hasAnyMatches(list: numbers, condition: lessThanTen)

// Closures
numbers.map({ (number: Int) -> Int in
    let result: Int
    if (number % 2 == 0) {
        result = number * 3
    } else {
        result = 0
    }
    return result
})

// Shorter closures
let mappedNumbers = numbers.map({ number in 3 * number})
print(mappedNumbers)

// Can move closure outside the brackets if it's the last argument
// Can omit brackets if closure's the only argument
let sortedNumbers = numbers.sorted { $0 > $1 }
print(sortedNumbers)

// Classes
class Shape {
    var numberOfSides = 0
    let dimensions = 2
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
    
    func describe(name: String) -> String {
        return "\(name) has \(numberOfSides) sides and \(dimensions) dimensions."
    }
    
    deinit {
        // Cleanup on object destruction
    }
}
let square = Shape(name: "Square")
square.numberOfSides = 4
print(square.simpleDescription())
print(square.describe(name: "Square"))

// Subclassing
class Square: Shape {
    var sideLength: Double
    
    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 4
    }
    
    func area() -> Double {
        return sideLength * sideLength
    }
    
    override func simpleDescription() -> String {
        return "A square with sides of length \(sideLength)."
    }
}
let test = Square(sideLength: 5.2, name: "my test square")
test.area()
test.simpleDescription()

class Circle: Shape {
    var radius: Double
    
    init(radius: Double, name: String) {
        self.radius = radius
        super.init(name: name)
        numberOfSides = 0
    }
    
    func area() -> Double {
        return 2 * 3.14 * radius
    }
    
    override func simpleDescription() -> String {
        return "A circle with radius \(radius)."
    }
}
let circle = Circle(radius: 1.4, name: "test circle")
circle.area()
print(circle.simpleDescription())

// Getters and setters
class EquilateralTriangle: Shape {
    var sideLength: Double = 0.0

    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 3
    }

    var perimeter: Double {
        get {
            return 3.0 * sideLength
        }
        // newValue is the implicit name of the setter parameter.
        // An explicit name can be provided inside parens.
        set {
            sideLength = newValue / 3.0
        }
    }

    override func simpleDescription() -> String {
        return "An equilateral triangle with sides of length \(sideLength)."
    }
}
var triangle = EquilateralTriangle(sideLength: 3.1, name: "a triangle")
print(triangle.perimeter)
triangle.perimeter = 9.9
print(triangle.sideLength)

class TriangleAndSquare {
    var triangle: EquilateralTriangle {
        // Will be called every time before the value is set.
        // didSet called every time after the value is set.
        willSet {
            square.sideLength = newValue.sideLength
        }
    }
    var square: Square {
        willSet {
            triangle.sideLength = newValue.sideLength
        }
    }
    init(size: Double, name: String) {
        square = Square(sideLength: size, name: name)
        triangle = EquilateralTriangle(sideLength: size, name: name)
    }
}
var triangleAndSquare = TriangleAndSquare(size: 10, name: "another test shape")
print(triangleAndSquare.square.sideLength)
print(triangleAndSquare.triangle.sideLength)
triangleAndSquare.square = Square(sideLength: 50, name: "larger square")
print(triangleAndSquare.triangle.sideLength)

// Safe calls
let optionalSquare: Square? = Square(sideLength: 2.5, name: "optional square")
let sideLength = optionalSquare?.sideLength

// Enums
enum Rank: Int {
    // First value gets auto-assigned to 0, unless explicitly specified
    case ace = 1
    // Subsequent values get assigned in order
    case two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king
    
    func simpleDescription() -> String {
        switch self {
        case .ace:
            return "ace"
        case .jack:
            return "jack"
        case .queen:
            return "queen"
        case .king:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
    
    func compareTo(rank: Rank) -> String {
        let result: String
        if rawValue < rank.rawValue {
            result = "smaller than"
        } else if rawValue > rank.rawValue {
            result = "larger than"
        } else {
            result = "equal to"
        }
        return result
    }
}
let ace = Rank.ace
let aceRawValue = ace.rawValue

print("King is \(Rank.king.compareTo(rank: Rank.ace)) Ace.")
print("King is \(Rank.king.compareTo(rank: Rank.queen)) Queen.")
print("King is \(Rank.king.compareTo(rank: Rank.king)) King.")

if let convertedRank = Rank(rawValue: 3) {
    let threeDescription = convertedRank.simpleDescription()
    print("Three means \(threeDescription).")
}

// Enums don't have to map to raw types
enum Suit {
    case spades, hearts, diamonds, clubs

    func simpleDescription() -> String {
        switch self {
        case .spades:
            return "spades"
        case .hearts:
            return "hearts"
        case .diamonds:
            return "diamonds"
        case .clubs:
            return "clubs"
        }
    }
    
    func color() -> String {
        switch self {
        case .spades, .clubs:
            return "black"
        case .hearts, .diamonds:
            return "red"
        }
    }
}
let hearts = Suit.hearts
let heartsDescription = hearts.simpleDescription()
let heartsColor = hearts.color()

enum ServerResponse {
    case result(String, String)
    case failure(String)
    case undefined
}

let success = ServerResponse.result("6:00 am", "8:09 pm")
let failure = ServerResponse.failure("Out of cheese.")
let undefined = ServerResponse.undefined

switch undefined {
case let .result(sunrise, sunset):
    print("Sunrise is at \(sunrise) and sunset is at \(sunset).")
case let .failure(message):
    print("Failure... \(message)")
case .undefined:
    print("Something's very wrong.")
}

// Structs
// Structs are always copied, classes are pass-by-reference
struct Card {
    var rank: Rank
    var suit: Suit
    func simpleDescription() -> String {
        return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
    }
}
let threeOfSpades = Card(rank: .three, suit: .spades)
let threeOfSpadesDescription = threeOfSpades.simpleDescription()

func deck() -> [Card] {
    var cards = [Card]()
    for suit in [Suit.clubs, Suit.diamonds, Suit.hearts, Suit.spades] {
        for rank in [Rank.ace, Rank.king, Rank.queen, Rank.jack, Rank.ten,
            Rank.nine, Rank.eight, Rank.seven, Rank.six, Rank.five, Rank.four,
            Rank.three, Rank.two] {
                cards.append(Card(rank: rank, suit: suit))
        }
    }
    return cards
}
print(deck().map { $0.simpleDescription() })

// Protocols
protocol ExampleProtocol {
    var simpleDescription: String { get }
    // mutating marks method as modifies the structure
    mutating func adjust()
}

class SimpleClass: ExampleProtocol {
    var simpleDescription: String = "A very simple class."
    var anotherProperty: Int = 69105
    // Can't have mutating cause class methods can always mutate fields
    func adjust() {
        simpleDescription += "  Now 100% adjusted."
    }
}
var a = SimpleClass()
a.adjust()
let aDescription = a.simpleDescription

struct SimpleStructure: ExampleProtocol {
    var simpleDescription: String = "A simple structure"
    mutating func adjust() {
        simpleDescription += " (adjusted)"
    }
}
var b = SimpleStructure()
b.adjust()
let bDescription = b.simpleDescription

// Extensions
extension Int: ExampleProtocol {
    var simpleDescription: String {
        return "The number \(self)"
    }
    mutating func adjust() {
        self += 42
    }
}
print(7.simpleDescription)
var i = 7
i.adjust()
print(i)

// Error Handling
// Errors should adopt Error protocol.
enum PrinterError: Error {
    case outOfPaper
    case noToner
    case onFire
}

class GeneralFailure: Error {
}

func send(job: Int, toPrinter printerName: String) throws -> String {
    if printerName == "Never Has Toner" {
        throw PrinterError.noToner
    }
    if job == 666 {
        throw PrinterError.onFire
    }
    if job < 0 {
        throw GeneralFailure()
    }
    return "Job sent"
}

do {
    let printerResponse = try send(job: -2, toPrinter: "Gutenberg")
    print(printerResponse)
} catch PrinterError.onFire  {
    print("I'll just put this over here, with the rest of the fire.")
} catch let printerError as PrinterError {
    print("Printer error: \(printerError).")
} catch {
    // error is the implicit name
    print(error)
}

// try? ignores the error and returns nil
let printerSuccess = try? send(job: 1884, toPrinter: "Mergenthaler")
let printerFailure = try? send(job: 1885, toPrinter: "Never Has Toner")

// defer
var fridgeIsOpen = false
let fridgeContent = ["milk", "eggs", "leftovers"]
func fridgeContents(_ food: String) -> Bool {
    fridgeIsOpen = true
    // defer is called after all other code in the function
    defer {
        fridgeIsOpen = false
    }
    let result = fridgeContent.contains(food)
    return result
}
fridgeContents("banana")
print(fridgeIsOpen)

// Generics
func makeArray<Item>(repeating item: Item, numberOfTimes: Int) -> [Item] {
    var result = [Item]()
    for _ in 0..<numberOfTimes {
        result.append(item)
    }
    return result
}
makeArray(repeating: "knock", numberOfTimes: 4)

enum OptionalValue<Wrapped> {
    case none
    case some(Wrapped)
}
var possibleInteger: OptionalValue<Int> = .none
possibleInteger = .some(100)

func anyCommonElements<T: Sequence, U: Sequence>(_ lhs: T, _ rhs: U) -> Bool
    where T.Element: Equatable, T.Element == U.Element {
    for lhsItem in lhs {
        for rhsItem in rhs {
            if lhsItem == rhsItem {
                return true
            }
        }
    }
    return false
}
anyCommonElements([1, 2, 3], [3])
