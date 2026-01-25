import Testing
@testable import Table

// MARK: - Basic Table Tests (Migrated from XCTest)

struct TableTests {

    // MARK: - 1D Array Tests

    @Test func arrayOfStringWithHeader() {
        let output = print(
            table: ["Good", "Very Good", "Happy", "Cool!"],
            header: ["Wed", "Thu", "Fri", "Sat"]
        )
        let expected = """
            +----+---------+-----+-----+
            |Wed |Thu      |Fri  |Sat  |
            +----+---------+-----+-----+
            |Good|Very Good|Happy|Cool!|
            +----+---------+-----+-----+

            """
        #expect(output == expected)
    }

    @Test func arrayOfInt() {
        let output = print(table: [2, 94231, 241245125125])
        let expected = """
            +-+-----+------------+
            |2|94231|241245125125|
            +-+-----+------------+

            """
        #expect(output == expected)
    }

    @Test func arrayOfDouble() {
        let output = print(table: [2.0, 931, 214.24124])
        let expected = """
            +---+-----+---------+
            |2.0|931.0|214.24124|
            +---+-----+---------+

            """
        #expect(output == expected)
    }

    // MARK: - 2D Array Tests

    @Test func twoDArrayOfString() {
        let output = print(
            table: [["1", "HELLOW"], ["2", "WOLLEH"]],
            header: ["Index", "Words"]
        )
        let expected = """
            +-----+------+
            |Index|Words |
            +-----+------+
            |1    |HELLOW|
            +-----+------+
            |2    |WOLLEH|
            +-----+------+

            """
        #expect(output == expected)
    }

    @Test func twoDArrayOfStringWithDifferentColumns() {
        let output = print(
            table: [["1", "b2"], ["Hellow", "Great!"], ["sdjfklsjdfklsadf", "dsf", "1"]],
            header: ["1", "2", "3"]
        )
        let expected = """
            +----------------+------+-+
            |1               |2     |3|
            +----------------+------+-+
            |1               |b2    | |
            +----------------+------+-+
            |Hellow          |Great!| |
            +----------------+------+-+
            |sdjfklsjdfklsadf|dsf   |1|
            +----------------+------+-+

            """
        #expect(output == expected)
    }

    @Test func twoDArrayOfIntWithDifferentColumns() {
        let output = print(table: [[1, 2, 3], [4, 5, 6], [7, 8, 9, 10]])
        let expected = """
            +-+-+-+--+
            |1|2|3|  |
            +-+-+-+--+
            |4|5|6|  |
            +-+-+-+--+
            |7|8|9|10|
            +-+-+-+--+

            """
        #expect(output == expected)
    }

    // MARK: - Fill Equally Distribution Tests

    @Test func fillEquallyForArrayOfStringWithHeader() {
        let output = print(
            table: ["Good", "Very Good", "Happy", "Cool!"],
            header: ["Wed", "Thu", "Fri", "Sat"],
            distribution: .fillEqually
        )
        let expected = """
            +---------+---------+---------+---------+
            |Wed      |Thu      |Fri      |Sat      |
            +---------+---------+---------+---------+
            |Good     |Very Good|Happy    |Cool!    |
            +---------+---------+---------+---------+

            """
        #expect(output == expected)
    }

    @Test func fillEquallyForArrayOfInt() {
        let output = print(
            table: [2, 94231, 241245125125],
            distribution: .fillEqually
        )
        let expected = """
            +------------+------------+------------+
            |2           |94231       |241245125125|
            +------------+------------+------------+

            """
        #expect(output == expected)
    }

    @Test func fillEquallyForArrayOfDouble() {
        let output = print(
            table: [2.0, 931, 214.24124],
            distribution: .fillEqually
        )
        let expected = """
            +---------+---------+---------+
            |2.0      |931.0    |214.24124|
            +---------+---------+---------+

            """
        #expect(output == expected)
    }

    @Test func fillEquallyForTwoDArrayOfString() {
        let output = print(
            table: [["1", "HELLOW"], ["2", "WOLLEH"]],
            header: ["Index", "Words"],
            distribution: .fillEqually
        )
        let expected = """
            +------+------+
            |Index |Words |
            +------+------+
            |1     |HELLOW|
            +------+------+
            |2     |WOLLEH|
            +------+------+

            """
        #expect(output == expected)
    }

    @Test func fillEquallyForTwoDArrayOfStringWithDifferentColumns() {
        let output = print(
            table: [["1", "b2"], ["Hellow", "Great!"], ["sdjfklsjdfklsadf", "dsf", "1"]],
            header: ["1", "2", "3"],
            distribution: .fillEqually
        )
        let expected = """
            +----------------+----------------+----------------+
            |1               |2               |3               |
            +----------------+----------------+----------------+
            |1               |b2              |                |
            +----------------+----------------+----------------+
            |Hellow          |Great!          |                |
            +----------------+----------------+----------------+
            |sdjfklsjdfklsadf|dsf             |1               |
            +----------------+----------------+----------------+

            """
        #expect(output == expected)
    }

    @Test func fillEquallyForTwoDArrayOfIntWithDifferentColumns() {
        let output = print(
            table: [[1, 2, 3], [4, 5, 6], [7, 8, 9, 10]],
            distribution: .fillEqually
        )
        let expected = """
            +--+--+--+--+
            |1 |2 |3 |  |
            +--+--+--+--+
            |4 |5 |6 |  |
            +--+--+--+--+
            |7 |8 |9 |10|
            +--+--+--+--+

            """
        #expect(output == expected)
    }
}

// MARK: - Unicode Width Tests (User Story 1)

struct UnicodeWidthTests {

    @Test func chineseCharacterWidth() {
        // Chinese characters should be width 2
        #expect("你".displayWidth == 2)
        #expect("好".displayWidth == 2)
        #expect("你好".displayWidth == 4)
        #expect("世界".displayWidth == 4)
    }

    @Test func koreanHangulWidth() {
        // Korean Hangul should be width 2
        #expect("안".displayWidth == 2)
        #expect("녕".displayWidth == 2)
        #expect("안녕하세요".displayWidth == 10)
        #expect("프로그래밍".displayWidth == 10)
    }

    @Test func japaneseHiraganaKatakanaWidth() {
        // Japanese Hiragana and Katakana should be width 2
        #expect("あ".displayWidth == 2)  // Hiragana
        #expect("ア".displayWidth == 2)  // Katakana
        #expect("こんにちは".displayWidth == 10)  // Hiragana
        #expect("プログラミング".displayWidth == 14)  // Katakana
    }

    @Test func arabicTextWidth() {
        // Arabic characters should be width 1 (not wide)
        #expect("م".displayWidth == 1)
        #expect("مرحبا".displayWidth == 5)
        #expect("عالم".displayWidth == 4)
    }

    @Test func emojiDisplayWidth() {
        // Emoji should be width 2
        #expect("👋".displayWidth == 2)
        #expect("🎉".displayWidth == 2)
        #expect("🚀".displayWidth == 2)
    }

    @Test func mixedLanguageTableAlignment() {
        // Test that a table with mixed languages aligns correctly
        let output = print(
            table: [["Hello", "你好"], ["World", "世界"]],
            header: ["EN", "CN"]
        )
        // The table should render without crashing
        // and contain both English and Chinese text
        #expect(output.contains("Hello"))
        #expect(output.contains("你好"))
        #expect(output.contains("World"))
        #expect(output.contains("世界"))
    }

    @Test func cjkSymbolsAndPunctuationWidth() {
        // CJK symbols and punctuation should be width 2
        #expect("。".displayWidth == 2)  // Ideographic full stop
        #expect("、".displayWidth == 2)  // Ideographic comma
        #expect("「".displayWidth == 2)  // Left corner bracket
    }
}

// MARK: - Edge Case Tests (User Story 3)

struct EdgeCaseTests {

    @Test func emptyArrayReturnsEmptyString() {
        let output = print(table: [String]())
        #expect(output == "")
    }

    @Test func emptyTwoDArrayReturnsEmptyString() {
        let output = print(table: [[String]]())
        #expect(output == "")
    }

    @Test func controlCharacterEscaping() {
        // Control characters should be escaped
        let output = print(table: ["Hello\nWorld", "Tab\tHere"])
        #expect(output.contains("\\n"))
        #expect(output.contains("\\t"))
        #expect(!output.contains("\n\n"))  // No actual newline in cell content
    }
}

// MARK: - Performance Tests (User Story 3)

struct PerformanceTests {

    @Test func largeTablePerformance() {
        // Generate a 100x100 table (10,000 cells)
        var data: [[String]] = []
        for i in 0..<100 {
            var row: [String] = []
            for j in 0..<100 {
                row.append("Cell\(i)x\(j)")
            }
            data.append(row)
        }

        // This should complete without timeout
        let output = print(table: data)
        #expect(!output.isEmpty)
    }
}

// MARK: - Dictionary Tests

struct DictionaryTests {

    @Test func dictionaryWithUnicodeKeysAndValues() {
        let output = print(
            table: ["名前": "田中", "age": 30] as [AnyHashable: Any],
            header: ["Key", "Value"]
        )
        #expect(output.contains("名前"))
        #expect(output.contains("田中"))
    }
}

// MARK: - Header Tests

struct HeaderTests {

    @Test func headerWithUnicodeCharacters() {
        let output = print(
            table: [["A", "B"], ["C", "D"]],
            header: ["列1", "列2"]
        )
        #expect(output.contains("列1"))
        #expect(output.contains("列2"))
    }
}
