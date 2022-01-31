import Foundation

// MARK: - Public

public struct Alphabet: Equatable, ExpressibleByStringLiteral {
    /// Base 36 is using all lowercases alphanumeric characters
    public static let base36: Alphabet = "0123456789abcdefghijklmnopqrstuvwxyz"
    /// Base 58 is flicker like convertion, excluding alike characters
    public static let base58: Alphabet = "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ"
    /// Base 62 is using all alphanumeric characters
    public static let base62: Alphabet = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    /// Base 64 is using all alphanumeric characters ; plus dash `-` and underscore `_`
    public static let base64: Alphabet = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-_"
    /// Base 90 is using all characters that are safe of use inside a cookie value.
    public static let base90: Alphabet = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!#$%&'()*+-./:<=>?@[]^_`{|}~"

    let characters: [Character]

    var base: Int {
        characters.count
    }

    public init(stringLiteral value: String) {
        characters = Array(value)
    }
}

extension UUID {
    /// Initialize an UUID using a shortened representation, and it's corresponding base alphabet
    public init(shortened: String, using alphabet: Alphabet) throws {
        self = try UUIDShortener.from(shortened, using: alphabet)
    }

    /// Retrieve the shortened representation of the UUID using the corresponding base alphabet
    public func shortened(using alphabet: Alphabet) throws -> String {
        try UUIDShortener.to(self, using: alphabet)
    }
}

// MARK: - Internals

extension Alphabet {
    static let base16: Alphabet = "0123456789abcdef"
}

extension UUID {
    var uuidStringWithoutDashes: String {
        uuidString.replacingOccurrences(of: "-", with: "")
    }
}

extension String {
    func withUUIDDashes() -> String {
        guard !contains("-"), count == 32 else {
            return self
        }

        let pattern = #"(\w{8})(\w{4})(\w{4})(\w{4})(\w{12})"#
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: self.utf16.count)
        let matches = regex.matches(in: self, options: [], range: range)

        guard let match = matches.first else {
            return self
        }

        var parts: [String] = []
        for i in 1..<match.numberOfRanges {
            if let range = Range(match.range(at: i), in: self) {
                parts.append(self[range].description)
            }
        }
        return parts.joined(separator: "-")
    }

    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
}

enum UUIDShortener {
    static func to(_ uuid: UUID, using alphabet: Alphabet) throws -> String {
        return try Converter(from: .base16, to: alphabet).convert(uuid.uuidStringWithoutDashes.lowercased())
    }

    static func from(_ shortened: String, using alphabet: Alphabet) throws -> UUID {
        guard let uuid = UUID(uuidString: try Converter(from: alphabet, to: .base16).convert(shortened).leftPadding(toLength: 32, withPad: "0").withUUIDDashes()) else {
            throw Converter.Errors.badAlphabet
        }
        return uuid
    }
}

struct Converter {
    enum Errors: Error {
        case badAlphabet
        case valueIncompatibleWithAlphabet
    }

    let from: Alphabet
    let to: Alphabet

    func convert(_ value: String) throws -> String {
        guard from != to else {
            return value
        }

        guard value.allSatisfy({ from.characters.contains($0) }) else {
            throw Errors.valueIncompatibleWithAlphabet
        }

        var numberMap: [Int] = []
        for char in value {
            if let number = from.characters.firstIndex(of: char) {
                numberMap.append(number)
            }
        }

        var length = value.count
        var divide: Int
        var newlen: Int
        var output = ""
        repeat {
            divide = 0
            newlen = 0
            for i in 0..<length {
                divide = divide * from.base + numberMap[i]
                if divide >= to.base {
                    numberMap[newlen] = divide / to.base
                    newlen += 1
                    divide = divide % to.base
                } else if newlen > 0 {
                    numberMap[newlen] = 0
                    newlen += 1
                }
            }
            length = newlen
            output = to.characters[divide].description + output
        } while newlen != 0
        return output
    }
}
