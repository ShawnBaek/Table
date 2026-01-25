import Testing
import os
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

// MARK: - Table Style Tests

struct TableStyleTests {

    @Test func unicodeStyleTable() {
        let output = print(
            table: [["1", "HELLO"], ["2", "WORLD"]],
            header: ["ID", "Word"],
            style: .unicode
        )
        // Unicode box-drawing characters
        #expect(output.contains("┌"))  // Top left corner
        #expect(output.contains("┐"))  // Top right corner
        #expect(output.contains("└"))  // Bottom left corner
        #expect(output.contains("┘"))  // Bottom right corner
        #expect(output.contains("─"))  // Horizontal line
        #expect(output.contains("│"))  // Vertical line
        #expect(output.contains("├"))  // Left T junction
        #expect(output.contains("┤"))  // Right T junction
        #expect(output.contains("┬"))  // Top T junction
        #expect(output.contains("┴"))  // Bottom T junction
    }

    @Test func asciiStyleTable() {
        let output = print(
            table: [["1", "HELLO"], ["2", "WORLD"]],
            header: ["ID", "Word"],
            style: .ascii
        )
        // ASCII characters
        #expect(output.contains("+"))  // Corners and junctions
        #expect(output.contains("-"))  // Horizontal line
        #expect(output.contains("|"))  // Vertical line
        // Should NOT contain Unicode box-drawing
        #expect(!output.contains("┌"))
        #expect(!output.contains("─"))
        #expect(!output.contains("│"))
    }

    @Test func unicodeStyleTableOutput() {
        let output = print(
            table: [["A", "B"], ["C", "D"]],
            header: ["X", "Y"],
            style: .unicode
        )
        let expected = """
            ┌─┬─┐
            │X│Y│
            ├─┼─┤
            │A│B│
            ├─┼─┤
            │C│D│
            └─┴─┘

            """
        #expect(output == expected)
    }

    @Test func asciiStyleTableOutput() {
        let output = print(
            table: [["A", "B"], ["C", "D"]],
            header: ["X", "Y"],
            style: .ascii
        )
        let expected = """
            +-+-+
            |X|Y|
            +-+-+
            |A|B|
            +-+-+
            |C|D|
            +-+-+

            """
        #expect(output == expected)
    }
}

// MARK: - Edge Cases with Varying Widths and Empty Cells

struct VariableWidthTests {

    @Test func tableWithVeryLongAndShortColumns() {
        let output = print(
            table: [
                ["A", "This is a very long text that spans many characters", "B"],
                ["X", "Short", "Y"]
            ],
            header: ["Col1", "Col2", "Col3"],
            style: .ascii
        )
        #expect(output.contains("This is a very long text that spans many characters"))
        #expect(output.contains("Short"))
        // Verify alignment - short values should be padded
        #expect(output.contains("|A   |"))
        #expect(output.contains("|X   |"))
    }

    @Test func tableWithEmptyCells() {
        let output = print(
            table: [
                ["", "Value1", ""],
                ["Value2", "", "Value3"],
                ["", "", ""]
            ],
            header: ["A", "B", "C"],
            style: .unicode
        )
        #expect(output.contains("│"))
        #expect(output.contains("Value1"))
        #expect(output.contains("Value2"))
        #expect(output.contains("Value3"))
    }

    @Test func tableWithMixedEmptyAndLongCells() {
        let output = print(
            table: [
                ["", "A very long value here", ""],
                ["Short", "", "Another long value"],
                ["", "", ""]
            ],
            style: .unicode
        )
        #expect(!output.isEmpty)
        #expect(output.contains("A very long value here"))
        #expect(output.contains("Another long value"))
        #expect(output.contains("Short"))
    }

    @Test func tableWithUnevenRowLengths() {
        // Some rows have fewer columns than others
        let output = print(
            table: [
                ["A", "B", "C", "D", "E"],
                ["1", "2"],
                ["X", "Y", "Z"]
            ],
            style: .ascii
        )
        #expect(output.contains("|A|"))
        #expect(output.contains("|1|"))
        #expect(output.contains("|X|"))
        // Empty cells should be represented with spaces
        #expect(output.contains("| |"))
    }

    @Test func unicodeTableWithEmptyCellsOutput() {
        let output = print(
            table: [["A", "", "C"], ["", "B", ""]],
            style: .unicode
        )
        let expected = """
            ┌─┬─┬─┐
            │A│ │C│
            ├─┼─┼─┤
            │ │B│ │
            └─┴─┴─┘

            """
        #expect(output == expected)
    }

    @Test func tableWithSingleEmptyCell() {
        let output = print(
            table: [[""]],
            style: .unicode
        )
        #expect(output.contains("┌┐"))
        #expect(output.contains("││"))
        #expect(output.contains("└┘"))
    }

    @Test func tableWithMixedUnicodeAndEmptyCells() {
        let output = print(
            table: [
                ["你好", "", "Hello"],
                ["", "世界", ""],
                ["🎉", "", "🚀"]
            ],
            style: .unicode
        )
        #expect(output.contains("你好"))
        #expect(output.contains("世界"))
        #expect(output.contains("Hello"))
        #expect(output.contains("🎉"))
        #expect(output.contains("🚀"))
    }

    @Test func dictionaryTableVerifyOutput() {
        let output = print(
            table: ["key1": "short", "longerKey": "a much longer value here"] as [AnyHashable: Any],
            header: ["Key", "Value"],
            style: .unicode
        )
        #expect(output.contains("key1"))
        #expect(output.contains("longerKey"))
        #expect(output.contains("short"))
        #expect(output.contains("a much longer value here"))
    }

    @Test func singleRowTableOutput() {
        let output = print(
            table: ["Only", "One", "Row"],
            style: .unicode
        )
        let expected = """
            ┌────┬───┬───┐
            │Only│One│Row│
            └────┴───┴───┘

            """
        #expect(output == expected)
    }

    @Test func singleColumnTableOutput() {
        let output = print(
            table: [["A"], ["B"], ["C"]],
            style: .unicode
        )
        let expected = """
            ┌─┐
            │A│
            ├─┤
            │B│
            ├─┤
            │C│
            └─┘

            """
        #expect(output == expected)
    }
}

// MARK: - Logger Integration Tests

struct LoggerIntegrationTests {

    @Test func tableOutputCanBeLoggedWithOSLogger() {
        // Create a Logger instance
        let logger = Logger(subsystem: "com.table.tests", category: "TableTests")

        // Generate table output
        let tableOutput = print(
            table: [["Alice", "30"], ["Bob", "25"]],
            header: ["Name", "Age"],
            style: .unicode
        )

        // Verify the output is a valid non-empty string that can be logged
        #expect(!tableOutput.isEmpty)
        #expect(tableOutput.contains("Alice"))
        #expect(tableOutput.contains("Bob"))

        // Log the table output (this verifies Logger accepts the string)
        logger.info("Table output:\n\(tableOutput)")

        // Also test with different log levels
        logger.debug("Debug table:\n\(tableOutput)")
        logger.notice("Notice table:\n\(tableOutput)")
    }

    @Test func tableOutputWithUnicodeCanBeLogged() {
        let logger = Logger(subsystem: "com.table.tests", category: "UnicodeTests")

        // Generate table with Unicode content
        let tableOutput = print(
            table: [["Hello", "你好"], ["World", "世界"]],
            header: ["EN", "CN"],
            style: .unicode
        )

        #expect(!tableOutput.isEmpty)
        #expect(tableOutput.contains("你好"))
        #expect(tableOutput.contains("世界"))

        // Log Unicode content
        logger.info("Unicode table:\n\(tableOutput)")
    }

    @Test func tableOutputToCustomTextOutputStream() {
        // Test that Table works with custom TextOutputStream (similar to how Logger might capture output)
        var capturedOutput = ""
        _ = print(
            table: ["A", "B", "C"],
            style: .ascii,
            stream: &capturedOutput
        )

        #expect(!capturedOutput.isEmpty)
        #expect(capturedOutput.contains("A"))
        #expect(capturedOutput.contains("B"))
        #expect(capturedOutput.contains("C"))
    }
}

// MARK: - Logger.table() Extension Tests

struct LoggerTableExtensionTests {

    @Test func loggerTableWith1DStringArray() {
        let logger = Logger(subsystem: "com.table.tests", category: "LoggerExtension")

        // This should compile and run without errors
        logger.table(["Good", "Very Good", "Happy", "Cool!"], header: ["Wed", "Thu", "Fri", "Sat"])
    }

    @Test func loggerTableWith1DIntArray() {
        let logger = Logger(subsystem: "com.table.tests", category: "LoggerExtension")

        logger.table([2, 94231, 241245125125])
    }

    @Test func loggerTableWith1DDoubleArray() {
        let logger = Logger(subsystem: "com.table.tests", category: "LoggerExtension")

        logger.table([2.0, 931, 214.24124])
    }

    @Test func loggerTableWith2DStringArray() {
        let logger = Logger(subsystem: "com.table.tests", category: "LoggerExtension")

        logger.table([["1", "HELLOW"], ["2", "WOLLEH"]], header: ["Index", "Words"])
    }

    @Test func loggerTableWith2DStringArrayUnequalColumns() {
        let logger = Logger(subsystem: "com.table.tests", category: "LoggerExtension")

        logger.table([["1", "b2"], ["Hellow", "Great!"], ["sdjfklsjdfklsadf", "dsf", "1"]])
    }

    @Test func loggerTableWith2DIntArrayUnequalColumns() {
        let logger = Logger(subsystem: "com.table.tests", category: "LoggerExtension")

        logger.table([[1, 2, 3], [4, 5, 6], [7, 8, 9, 10]])
    }

    @Test func loggerTableWithDictionary() {
        let logger = Logger(subsystem: "com.table.tests", category: "LoggerExtension")

        logger.table(["1": 1, "key2": "Hellow?", "key3": 0, "I'm Table": [1, 2, 3, 2, 1]] as [AnyHashable: Any], header: ["key", "value"])
    }

    @Test func loggerTableWithDifferentStyles() {
        let logger = Logger(subsystem: "com.table.tests", category: "LoggerExtension")

        // ASCII style
        logger.table(["A", "B", "C"], style: .ascii)

        // Unicode style (default)
        logger.table(["A", "B", "C"], style: .unicode)
    }

    @Test func loggerTableWithDifferentLogLevels() {
        let logger = Logger(subsystem: "com.table.tests", category: "LoggerExtension")

        // Different log levels
        logger.table(["Debug"], level: .debug)
        logger.table(["Info"], level: .info)
        logger.table(["Error"], level: .error)
        logger.table(["Fault"], level: .fault)
    }

    @Test func loggerTableWithUnicodeContent() {
        let logger = Logger(subsystem: "com.table.tests", category: "LoggerExtension")

        logger.table([
            ["Hello", "你好", "こんにちは"],
            ["World", "世界", "世界"]
        ], header: ["EN", "CN", "JP"])
    }

    @Test func loggerTableWithEmoji() {
        let logger = Logger(subsystem: "com.table.tests", category: "LoggerExtension")

        logger.table(["👋", "🎉", "🚀", "👨‍👩‍👧‍👦"])
    }

    @Test func loggerTableWithFillEqually() {
        let logger = Logger(subsystem: "com.table.tests", category: "LoggerExtension")

        logger.table(
            ["Short", "A much longer value"],
            distribution: .fillEqually,
            style: .unicode
        )
    }
}
