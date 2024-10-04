import Foundation

struct NegativeAmountError: Error {}
struct NoSuchFileError: Error {}

func change(_ amount: Int) -> Result<[Int:Int], NegativeAmountError> {
    if amount < 0 {
        return .failure(NegativeAmountError())
    }
    var (counts, remaining) = ([Int:Int](), amount)
    for denomination in [25, 10, 5, 1] {
        (counts[denomination], remaining) = 
            remaining.quotientAndRemainder(dividingBy: denomination)
    }
    return .success(counts)
}

// first then lower case function here
func firstThenLowerCase(of array: [String], satisfying predicate: (String) -> Bool) -> String? {
    return array.first(where: predicate)?.lowercased()
}

// say function here
class Say {
    private var words: [String]

    init(_ word: String = "") {
        self.words = [word]
    }

    func and(_ word: String) -> Say {
        var newWords = words
        newWords.append(word)
        return Say(newWords.joined(separator: " "))
    }

    var phrase: String {
        return words.joined(separator: " ")
    }
}

func say(_ word: String = "") -> Say {
    return Say(word)
}

// meaningfulLineCount function here
enum FileError: Error {
    case fileNotFound
}

func meaningfulLineCount(_ filename: String) async -> Result<Int, Error> {
    do {
        let fileURL = URL(fileURLWithPath: filename)
        let fileHandle = try FileHandle(forReadingFrom: fileURL)
        defer {
            try? fileHandle.close()
        }
        var count = 0

        for try await line in fileHandle.bytes.lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            if !trimmedLine.isEmpty && !trimmedLine.hasPrefix("#") {
                count += 1
            }
        }

        return .success(count)
    } catch {
        return .failure(FileError.fileNotFound)
    }
}

//  Quaternion struct here
struct Quaternion : CustomStringConvertible {
    let a: Double
    let b: Double
    let c: Double
    let d: Double

    static let ZERO = Quaternion(a: 0, b: 0, c: 0, d: 0)
    static let I = Quaternion(a: 0, b: 1, c: 0, d: 0)
    static let J = Quaternion(a: 0, b: 0, c: 1, d: 0)
    static let K = Quaternion(a: 0, b: 0, c: 0, d: 1)

    init(a: Double = 0, b: Double = 0, c: Double = 0, d: Double = 0) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }

    var coefficients: [Double] {
        return [self.a, self.b, self.c, self.d]
    }

    var conjugate: Quaternion {
        return Quaternion(
            a: self.a,
            b: -1 * self.b,
            c: -1 * self.c,
            d: -1 * self.d
        )
    }

    var description: String {
        if self == Quaternion.ZERO {
            return "0"
        }

        var retString: String = ""

        func formatCo(value: Double, symbol: String) {
            switch value {
                case 0.0:
                    break
                case 1.0:
                    retString += (retString == "") ? "\(symbol)" : "+\(symbol)"
                case -1.0:
                    retString += "-\(symbol)"
                default:
                    retString += (value > 0.0)  ? "+\(value)\(symbol)" : "\(value)\(symbol)"
            }
        }

        if self.a != 0.0 {
            retString += "\(self.a)"
        }

        formatCo(value: self.b, symbol: "i")
        formatCo(value: self.c, symbol: "j")
        formatCo(value: self.d, symbol: "k")

        return retString
    }
}

func + (left: Quaternion, right: Quaternion) -> Quaternion {
    return Quaternion(
        a: left.a + right.a,
        b: left.b + right.b,
        c: left.c + right.c,
        d: left.d + right.d
    )
}

func * (left: Quaternion, right: Quaternion) -> Quaternion {
    return Quaternion(
        a: (left.a * right.a) - (left.b * right.b) - (left.c * right.c) - (left.d * right.d),
        b: (left.a * right.b) + (left.b * right.a) + (left.c * right.d) - (left.d * right.c),
        c: (left.a * right.c) - (left.b * right.d) + (left.c * right.a) + (left.d * right.b),
        d: (left.a * right.d) + (left.b * right.c) - (left.c * right.b) + (left.d * right.a)
    )
}

func == (left: Quaternion, right: Quaternion) -> Bool {
    return
        (left.a == right.a &&
         left.b == right.b &&
         left.c == right.c &&
         left.d == right.d)
}

// Binary Search Tree enum here
indirect enum BinarySearchTree: CustomStringConvertible {
    case empty
    case node(BinarySearchTree, String, BinarySearchTree)

    var size: Int {
        switch self {
        case .empty:
            return 0
        case .node(let left, _, let right):
            return 1 + left.size + right.size
        }
    }

    var description: String {
        switch self {
        case .empty:
            return "()"
        case let .node(left, value, right):
            let treeString = "(\(left)\(value)\(right))"
            return treeString.replacingOccurrences(of: "()", with: "")
        }
    }

    func contains(_ searchValue: String) -> Bool {
        switch self {
        case .empty:
            return false
        case let .node(left, value, right):
            if value == searchValue {
                return true
            } else if searchValue < value {
                return left.contains(searchValue)
            } else {
                return right.contains(searchValue)
            }
        }
    }

    func insert(_ newValue: String) -> BinarySearchTree {
        switch self {
        case .empty:
            return .node(.empty, newValue, .empty)
        case let .node(left, value, right):
            if newValue < value {
                return .node(left.insert(newValue), value, right)
            } else if newValue > value {
                return .node(left, value, right.insert(newValue))
            } else {
                return self
            }
        }
    }
}
