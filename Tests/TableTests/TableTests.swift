import XCTest
@testable import Table

final class TableTests: XCTestCase {
    func test_1DArray_Of_String_with_header() {
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
        XCTAssertEqual(output, expected)
    }
    
    func test_1DArray_Of_Int() {
        let output = print(table: [2, 94231, 241245125125])
        let expected = """
            +-+-----+------------+
            |2|94231|241245125125|
            +-+-----+------------+

            """
        XCTAssertEqual(output, expected)
    }
    
    func test_1DArray_Of_Double() {
        let output = print(table: [2.0, 931, 214.24124])
        let expected = """
            +---+-----+---------+
            |2.0|931.0|214.24124|
            +---+-----+---------+

            """
        XCTAssertEqual(output, expected)
    }
    
    func test_2DArray_Of_String() {
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
        XCTAssertEqual(output, expected)
    }
    
    func test_2DArray_Of_String_With_Different_Columns() {
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
        XCTAssertEqual(output, expected)
    }
    
    func test_2DArray_Of_Int_With_Different_Columns() {
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
        XCTAssertEqual(output, expected)
    }
    
    func test_equalSpacing_for_1DArray_Of_String_with_header() {
        let output = print(
            table: ["Good", "Very Good", "Happy", "Cool!"],
            header: ["Wed", "Thu", "Fri", "Sat"],
            distribution: .equalSpacing
        )
        let expected = """
            +---------+---------+---------+---------+
            |Wed      |Thu      |Fri      |Sat      |
            +---------+---------+---------+---------+
            |Good     |Very Good|Happy    |Cool!    |
            +---------+---------+---------+---------+

            """
        XCTAssertEqual(output, expected)
    }
    
    func test_equalSpacing_for_1DArray_Of_Int() {
        let output = print(
            table: [2, 94231, 241245125125],
            distribution: .equalSpacing
        )
        let expected = """
            +------------+------------+------------+
            |2           |94231       |241245125125|
            +------------+------------+------------+

            """
        XCTAssertEqual(output, expected)
    }
    
    func test_equalSpacing_for_1DArray_Of_Double() {
        let output = print(
            table: [2.0, 931, 214.24124],
            distribution: .equalSpacing
        )
        let expected = """
            +---------+---------+---------+
            |2.0      |931.0    |214.24124|
            +---------+---------+---------+

            """
        XCTAssertEqual(output, expected)
    }
    
    func test_equalSpacing_for_2DArray_Of_String() {
        let output = print(
            table: [["1", "HELLOW"], ["2", "WOLLEH"]],
            header: ["Index", "Words"],
            distribution: .equalSpacing
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
        XCTAssertEqual(output, expected)
    }
    
    func test_equalSpacing_for_2DArray_Of_String_With_Different_Columns() {
        let output = print(
            table: [["1", "b2"], ["Hellow", "Great!"], ["sdjfklsjdfklsadf", "dsf", "1"]],
            header: ["1", "2", "3"],
            distribution: .equalSpacing
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
        XCTAssertEqual(output, expected)
    }
    
    func test_equalSpacing_for_2DArray_Of_Int_With_Different_Columns() {
        let output = print(
            table: [[1, 2, 3], [4, 5, 6], [7, 8, 9, 10]],
            distribution: .equalSpacing
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
        XCTAssertEqual(output, expected)
    }
    
    //TODO:- Add Test for Dictionary
}
