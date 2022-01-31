import XCTest
@testable import UUIDShortener

final class UUIDShortenerTests: XCTestCase {

    func testAllSizes() throws {
        let uuid = UUID()
        print(uuid)
        print(try uuid.shortened(using: .base36))
        print(try uuid.shortened(using: .base58))
        print(try uuid.shortened(using: .base62))
        print(try uuid.shortened(using: .base64))
        print(try uuid.shortened(using: .base90))
    }

    func testShorteningBackAndForthBaseCustom() throws {
        let uuid = UUID()
        let alphabet: Alphabet = "0123456789ABCDEF"
        let shortened = try uuid.shortened(using: alphabet)
        XCTAssertEqual(shortened, uuid.uuidStringWithoutDashes)
        let other = try UUID(shortened: shortened, using: alphabet)
        XCTAssertEqual(uuid, other)
    }

    func testShorteningBackAndForthBase36() throws {
        let uuid = UUID()
        let alphabet = Alphabet.base36
        let shortened = try uuid.shortened(using: alphabet)
        let other = try UUID(shortened: shortened, using: alphabet)
        XCTAssertEqual(uuid, other)
    }

    func testShorteningBackAndForthBase58() throws {
        let uuid = UUID()
        let alphabet = Alphabet.base58
        let shortened = try uuid.shortened(using: alphabet)
        let other = try UUID(shortened: shortened, using: alphabet)
        XCTAssertEqual(uuid, other)
    }

    func testShorteningBackAndForthBase62() throws {
        let uuid = UUID()
        let alphabet = Alphabet.base62
        let shortened = try uuid.shortened(using: alphabet)
        let other = try UUID(shortened: shortened, using: alphabet)
        XCTAssertEqual(uuid, other)
    }

    func testShorteningBackAndForthBase64() throws {
        let uuid = UUID()
        let alphabet = Alphabet.base64
        let shortened = try uuid.shortened(using: alphabet)
        let other = try UUID(shortened: shortened, using: alphabet)
        XCTAssertEqual(uuid, other)
    }

    func testShorteningBackAndForthBase90() throws {
        let uuid = UUID()
        let alphabet = Alphabet.base90
        let shortened = try uuid.shortened(using: alphabet)
        let other = try UUID(shortened: shortened, using: alphabet)
        XCTAssertEqual(uuid, other)
    }
}
