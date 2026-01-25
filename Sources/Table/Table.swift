//
//  Table.swift
//  print(table: [], header: [], terminator: "\n")
//
//  Created by BaekSungwook on 3/5/20.
//  Copyright © 2020 BaekSungwook. All rights reserved.
//

// MARK: - Control Character Escaping

/// Escape control characters to prevent table layout corruption
private func escapeControlCharacters(_ string: String) -> String {
    var result = ""
    for char in string {
        switch char {
        case "\n":
            result += "\\n"
        case "\t":
            result += "\\t"
        case "\r":
            result += "\\r"
        case "\0":
            result += "\\0"
        default:
            result.append(char)
        }
    }
    return result
}

// MARK: - Unicode Width Extensions

extension String {
    /// Calculate the display width of the string
    /// CJK characters and other full-width characters count as 2 spaces
    var displayWidth: Int {
        return self.reduce(0) { $0 + $1.displayWidth }
    }
}

extension Character {
    /// Calculate the display width of a character following UAX #11
    /// CJK characters, emoji, and other full-width characters count as 2 spaces
    var displayWidth: Int {
        // ASCII characters (most English letters, numbers, basic symbols)
        if self.isASCII {
            return 1
        }

        let unicodeScalars = self.unicodeScalars
        guard let firstScalar = unicodeScalars.first else {
            return 1
        }

        // Check for emoji first (emoji should be width 2)
        // Emoji with presentation selector (U+FE0F) or emoji presentation property
        if firstScalar.properties.isEmoji {
            // Check for emoji presentation or variation selector
            if firstScalar.properties.isEmojiPresentation ||
               unicodeScalars.contains(where: { $0.value == 0xFE0F }) {
                return 2
            }
            // Common emoji ranges that should be width 2
            let value = firstScalar.value
            if (0x1F300...0x1F9FF).contains(value) ||  // Misc Symbols, Emoticons, etc.
               (0x1FA00...0x1FAFF).contains(value) ||  // Extended-A
               (0x2600...0x26FF).contains(value) ||    // Misc Symbols
               (0x2700...0x27BF).contains(value) {     // Dingbats
                return 2
            }
        }

        let value = firstScalar.value

        // Wide (W) and Fullwidth (F) characters per UAX #11
        // These all have display width 2
        if (0x1100...0x115F).contains(value) ||    // Hangul Jamo (initial consonants)
           (0x231A...0x231B).contains(value) ||    // Watch, Hourglass
           (0x2329...0x232A).contains(value) ||    // Angle brackets
           (0x23E9...0x23F3).contains(value) ||    // Various symbols
           (0x23F8...0x23FA).contains(value) ||    // Various symbols
           (0x25FD...0x25FE).contains(value) ||    // Medium squares
           (0x2614...0x2615).contains(value) ||    // Umbrella, Hot beverage
           (0x2648...0x2653).contains(value) ||    // Zodiac symbols
           (0x26AA...0x26AB).contains(value) ||    // Circles
           (0x26BD...0x26BE).contains(value) ||    // Soccer, Baseball
           (0x26C4...0x26C5).contains(value) ||    // Snowman, Sun
           (0x26F2...0x26F3).contains(value) ||    // Fountain, Golf
           (0x2708...0x270D).contains(value) ||    // Various symbols
           (0x2733...0x2734).contains(value) ||    // Eight spoked asterisk
           (0x2753...0x2755).contains(value) ||    // Question marks
           (0x2763...0x2764).contains(value) ||    // Hearts
           (0x2795...0x2797).contains(value) ||    // Math symbols
           (0x2934...0x2935).contains(value) ||    // Arrows
           (0x2B05...0x2B07).contains(value) ||    // Arrows
           (0x2B1B...0x2B1C).contains(value) ||    // Squares
           (0x2E80...0x2EFF).contains(value) ||    // CJK Radicals Supplement
           (0x2F00...0x2FDF).contains(value) ||    // Kangxi Radicals
           (0x2FF0...0x2FFF).contains(value) ||    // Ideographic Description
           (0x3000...0x303E).contains(value) ||    // CJK Symbols and Punctuation
           (0x3041...0x3096).contains(value) ||    // Hiragana
           (0x3099...0x30FF).contains(value) ||    // Hiragana/Katakana
           (0x3105...0x312F).contains(value) ||    // Bopomofo
           (0x3131...0x318E).contains(value) ||    // Hangul Compatibility Jamo
           (0x3190...0x31FF).contains(value) ||    // Kanbun, Bopomofo Extended, etc.
           (0x3200...0x321E).contains(value) ||    // Enclosed CJK Letters
           (0x3220...0x3247).contains(value) ||    // Enclosed CJK Letters continued
           (0x3250...0x4DBF).contains(value) ||    // CJK Extension A and more
           (0x4E00...0x9FFF).contains(value) ||    // CJK Unified Ideographs
           (0xA960...0xA97F).contains(value) ||    // Hangul Jamo Extended-A
           (0xAC00...0xD7A3).contains(value) ||    // Hangul Syllables
           (0xD7B0...0xD7FF).contains(value) ||    // Hangul Jamo Extended-B
           (0xF900...0xFAFF).contains(value) ||    // CJK Compatibility Ideographs
           (0xFE10...0xFE1F).contains(value) ||    // Vertical Forms
           (0xFE30...0xFE6F).contains(value) ||    // CJK Compatibility Forms
           (0xFF01...0xFF60).contains(value) ||    // Fullwidth ASCII variants
           (0xFFE0...0xFFE6).contains(value) {     // Fullwidth symbols
            return 2
        }

        // Supplementary planes (CJK Extension B and beyond)
        if (0x20000...0x2FFFF).contains(value) ||  // Supplementary Ideographic Plane
           (0x30000...0x3FFFF).contains(value) {   // Tertiary Ideographic Plane
            return 2
        }

        // All other characters (Arabic, Cyrillic, Latin Extended, etc.) default to width 1
        return 1
    }
}

public enum TableSpacing: Sendable {
    case fillProportionally
    case fillEqually
}

/// Table border style
public enum TableStyle: Sendable {
    /// ASCII characters: + - |
    case ascii
    /// Unicode box-drawing characters: ┌ ─ ┐ │ └ ┘ ├ ┤ ┬ ┴ ┼
    case unicode
}

/// Position of a horizontal line in the table
private enum LinePosition {
    case top
    case middle
    case bottom
}

/// Box-drawing characters for table rendering
private struct BoxCharacters {
    let horizontal: Character
    let vertical: Character
    let topLeft: Character
    let topRight: Character
    let bottomLeft: Character
    let bottomRight: Character
    let leftT: Character
    let rightT: Character
    let topT: Character
    let bottomT: Character
    let cross: Character

    static let ascii = BoxCharacters(
        horizontal: "-",
        vertical: "|",
        topLeft: "+",
        topRight: "+",
        bottomLeft: "+",
        bottomRight: "+",
        leftT: "+",
        rightT: "+",
        topT: "+",
        bottomT: "+",
        cross: "+"
    )

    static let unicode = BoxCharacters(
        horizontal: "─",
        vertical: "│",
        topLeft: "┌",
        topRight: "┐",
        bottomLeft: "└",
        bottomRight: "┘",
        leftT: "├",
        rightT: "┤",
        topT: "┬",
        bottomT: "┴",
        cross: "┼"
    )

    static func characters(for style: TableStyle) -> BoxCharacters {
        switch style {
        case .ascii: return .ascii
        case .unicode: return .unicode
        }
    }

    func leftCorner(for position: LinePosition) -> Character {
        switch position {
        case .top: return topLeft
        case .middle: return leftT
        case .bottom: return bottomLeft
        }
    }

    func rightCorner(for position: LinePosition) -> Character {
        switch position {
        case .top: return topRight
        case .middle: return rightT
        case .bottom: return bottomRight
        }
    }

    func junction(for position: LinePosition) -> Character {
        switch position {
        case .top: return topT
        case .middle: return cross
        case .bottom: return bottomT
        }
    }
}

/// Print data in table format
/// - Parameters:
///   - table: Zero or more items to print.
///   - header: A string to print header on table.
///   - distribution: A spacing for item
///   - style: Table border style (.ascii or .unicode)
///   - terminator: A string to print end of function.
@discardableResult public func print(
    table data: Any,
    header: [String]? = nil,
    distribution: TableSpacing = .fillProportionally,
    style: TableStyle = .ascii,
    terminator: String = ""
) -> String {
    struct DefaultStream: TextOutputStream {
        func write(_ string: String) {
            print(string, terminator: "")
        }
    }

    var defaultStream = DefaultStream()

    return print(
        table: data,
        header: header,
        distribution: distribution,
        style: style,
        terminator: terminator,
        stream: &defaultStream
    )
}

@discardableResult public func print<Stream: TextOutputStream>(
    table data: Any,
    header: [String]? = nil,
    distribution: TableSpacing = .fillProportionally,
    style: TableStyle = .ascii,
    terminator: String = "",
    stream: inout Stream
) -> String {
    var result = ""
    let mirrorObj = Mirror(reflecting: data)
    let box = BoxCharacters.characters(for: style)
    if mirrorObj.subjectType == [String].self {
        let inputData = data as! [String]
        var info = tableInfo(data: inputData)
        let hasHeader = header != nil
        if let header = header {
            assert(header.count == inputData.count, "header should be equal items")
            for (index, title) in header.enumerated() {
                let infoWidth = info.widthInfo[index]!
                info.widthInfo[index] = max(infoWidth, title.displayWidth)
            }
            result.append(print(header: header, info: info, distribution: distribution, box: box, stream: &stream))
        }
        result.append(printTable(data: inputData, info: info, distribution: distribution, box: box, hasHeader: hasHeader, stream: &stream))
        print(terminator, to: &stream)
        result.append(terminator)
    }
    else if mirrorObj.subjectType == [Int].self {
        let inputData = data as! [Int]
        var info = tableInfo(data: inputData)
        let hasHeader = header != nil
        if let header = header {
            assert(header.count == inputData.count, "header should be equal items")
            for (index, title) in header.enumerated() {
                let infoWidth = info.widthInfo[index]!
                info.widthInfo[index] = max(infoWidth, title.displayWidth)
            }
            result.append(print(header: header, info: info, distribution: distribution, box: box, stream: &stream))
        }
        result.append(printTable(data: inputData, info: info, distribution: distribution, box: box, hasHeader: hasHeader, stream: &stream))
        print(terminator, to: &stream)
        result.append(terminator)
    }
    else if mirrorObj.subjectType == [Double].self {
        let inputData = data as! [Double]
        var info = tableInfo(data: inputData)
        let hasHeader = header != nil
        if let header = header {
            assert(header.count == inputData.count, "header should be equal items")
            for (index, title) in header.enumerated() {
                let infoWidth = info.widthInfo[index]!
                info.widthInfo[index] = max(infoWidth, title.displayWidth)
            }
            result.append(print(header: header, info: info, distribution: distribution, box: box, stream: &stream))
        }
        result.append(printTable(data: inputData, info: info, distribution: distribution, box: box, hasHeader: hasHeader, stream: &stream))
        print(terminator, to: &stream)
        result.append(terminator)
    }
    else if mirrorObj.subjectType == [AnyHashable: Any].self {
        let inputData = data as! [AnyHashable: Any]
        var info = tableInfo(data: inputData)
        let hasHeader = header != nil
        if let header = header {
            assert(header.count == 2, "header should be key, value for dictionary")
            for (index, title) in header.enumerated() {
                if index == 0 {
                    info.maxKeyWidth = max(info.maxKeyWidth, title.displayWidth)
                }
                else {
                    info.maxValueWidth = max(info.maxValueWidth, title.displayWidth)
                }
            }
            result.append(print(header: header, info: info, distribution: distribution, box: box, stream: &stream))
        }
        result.append(printTable(data: inputData, info: info, distribution: distribution, box: box, hasHeader: hasHeader, stream: &stream))
        print(terminator, to: &stream)
        result.append(terminator)
    }
    else if mirrorObj.subjectType == [[String]].self {
        let inputData = data as! [[String]]
        var info = tableInfo(data: inputData)
        let hasHeader = header != nil
        if let header = header {
            assert(inputData.map({ $0.count }).max() == header.count, "header should be equal items")
            for (index, title) in header.enumerated() {
                let infoWidth = info.widthInfo[index]!
                info.widthInfo[index] = max(infoWidth, title.displayWidth)
            }
            result.append(print(header: header, info: info, distribution: distribution, box: box, stream: &stream))
        }
        result.append(printTable(data: inputData, info: info, distribution: distribution, box: box, hasHeader: hasHeader, stream: &stream))
        print(terminator, to: &stream)
        result.append(terminator)
    }
    else if mirrorObj.subjectType == [[Int]].self {
        let inputData = data as! [[Int]]
        var info = tableInfo(data: inputData)
        let hasHeader = header != nil
        if let header = header {
            assert(inputData.map({ $0.count }).max() == header.count, "header should be equal items")
            for (index, title) in header.enumerated() {
                let infoWidth = info.widthInfo[index]!
                info.widthInfo[index] = max(infoWidth, title.displayWidth)
            }
            result.append(print(header: header, info: info, distribution: distribution, box: box, stream: &stream))
        }
        result.append(printTable(data: inputData, info: info, distribution: distribution, box: box, hasHeader: hasHeader, stream: &stream))
        print(terminator, to: &stream)
        result.append(terminator)
    }
    else if mirrorObj.subjectType == [[Double]].self {
        let inputData = data as! [[Double]]
        var info = tableInfo(data: inputData)
        let hasHeader = header != nil
        if let header = header {
            assert(inputData.map({ $0.count }).max() == header.count, "header should be equal items")
            for (index, title) in header.enumerated() {
                let infoWidth = info.widthInfo[index]!
                info.widthInfo[index] = max(infoWidth, title.displayWidth)
            }
            result.append(print(header: header, info: info, distribution: distribution, box: box, stream: &stream))
        }
        result.append(printTable(data: inputData, info: info, distribution: distribution, box: box, hasHeader: hasHeader, stream: &stream))
        print(terminator, to: &stream)
        result.append(terminator)
    }
    return result
}

@discardableResult private func print<Stream: TextOutputStream>(
    header: [String],
    info: (numberOfItem: Int, maxWidth: Int, widthInfo: [Int: Int]),
    distribution: TableSpacing,
    box: BoxCharacters,
    stream: inout Stream
) -> String {
    var result = ""
    let fullWidth = distribution == .fillProportionally ? info.widthInfo.reduce(0, { $0 + $1.value }) : info.maxWidth * info.numberOfItem
    let horizontalLine = horizontal(numberOfItems: info.numberOfItem, width: info.widthInfo, length: fullWidth, distribution: distribution, box: box, position: .top)
    print(horizontalLine, to: &stream)
    result.append("\(horizontalLine)\n")
    var row = "\(box.vertical)"
    for i in 0..<header.count {
        let width = distribution == .fillProportionally ? info.widthInfo[i]! : info.maxWidth
        let space = String(repeating: " ", count: width - header[i].displayWidth)
        let item = "\(header[i])\(space)\(box.vertical)"
        row += item
    }
    print(row, to: &stream)
    result.append("\(row)\n")
    return result
}

@discardableResult private func print<Stream: TextOutputStream>(
    header: [String],
    info: (numberOfItem: Int, maxKeyWidth: Int, maxValueWidth: Int, widthInfo: [String: Int]),
    distribution: TableSpacing,
    box: BoxCharacters,
    stream: inout Stream
) -> String {
    var result = ""
    let horizontalLine = horizontal(numberOfItems: info.numberOfItem, keyWidth: info.maxKeyWidth, valueWidth: info.maxValueWidth, distribution: distribution, box: box, position: .top)
    print(horizontalLine, to: &stream)
    result.append("\(horizontalLine)\n")
    var row = "\(box.vertical)"
    for i in 0..<header.count {
        var itemCount = 0
        if distribution == .fillProportionally {
            itemCount = i == 0 ? info.maxKeyWidth : info.maxValueWidth
        }
        else {
            itemCount = max(info.maxKeyWidth, info.maxValueWidth)
        }
        let space = String(repeating: " ", count: itemCount - header[i].displayWidth)
        let item = "\(header[i])\(space)\(box.vertical)"
        row += item
    }
    print(row, to: &stream)
    result.append("\(row)\n")
    return result
}

@discardableResult private func printTable<Stream: TextOutputStream>(
    data: [AnyHashable: Any],
    info: (numberOfItem: Int, maxKeyWidth: Int, maxValueWidth: Int, widthInfo: [String : Int]),
    distribution: TableSpacing,
    box: BoxCharacters,
    hasHeader: Bool,
    stream: inout Stream
) -> String {
    guard !data.isEmpty else { return "" }
    var result = ""
    let keys = Array(data.keys)
    let maxWidth = max(info.maxKeyWidth, info.maxValueWidth)

    for (index, key) in keys.enumerated() {
        let isFirst = index == 0
        let isLast = index == keys.count - 1

        // Top line (only if no header and first row)
        if isFirst && !hasHeader {
            let topLine = horizontal(numberOfItems: info.numberOfItem, keyWidth: info.maxKeyWidth, valueWidth: info.maxValueWidth, distribution: distribution, box: box, position: .top)
            print(topLine, to: &stream)
            result.append("\(topLine)\n")
        } else if isFirst && hasHeader {
            // Separator after header
            let midLine = horizontal(numberOfItems: info.numberOfItem, keyWidth: info.maxKeyWidth, valueWidth: info.maxValueWidth, distribution: distribution, box: box, position: .middle)
            print(midLine, to: &stream)
            result.append("\(midLine)\n")
        }

        var row = "\(box.vertical)"
        let keyValue = escapeControlCharacters(String(describing: key))
        let keyWidth = distribution == .fillProportionally ? info.maxKeyWidth : maxWidth
        let keySpace = String(repeating: " ", count: max(0, keyWidth - keyValue.displayWidth))
        let keyItem = "\(keyValue)\(keySpace)\(box.vertical)"
        row += keyItem
        let value = escapeControlCharacters(String(describing: data[key] ?? ""))
        let valueWidth = distribution == .fillProportionally ? info.maxValueWidth : maxWidth
        let space = String(repeating: " ", count: max(0, valueWidth - value.displayWidth))
        let item = "\(value)\(space)\(box.vertical)"
        row += item
        print(row, to: &stream)
        result.append("\(row)\n")

        // Bottom or middle line
        let linePosition: LinePosition = isLast ? .bottom : .middle
        let horizontalLine = horizontal(numberOfItems: info.numberOfItem, keyWidth: info.maxKeyWidth, valueWidth: info.maxValueWidth, distribution: distribution, box: box, position: linePosition)
        print(horizontalLine, to: &stream)
        result.append("\(horizontalLine)\n")
    }
    return result
}

@discardableResult private func printTable<Item: LosslessStringConvertible, Stream: TextOutputStream>(
    data: [Item],
    info: (numberOfItem: Int, maxWidth: Int, widthInfo: [Int: Int]),
    distribution: TableSpacing,
    box: BoxCharacters,
    hasHeader: Bool,
    stream: inout Stream
) -> String {
    guard info.numberOfItem > 0 else { return "" }
    var result = ""
    let fullWidth = distribution == .fillProportionally ? info.widthInfo.reduce(0, { $0 + $1.value }) : info.maxWidth * info.numberOfItem

    // Top line or separator after header
    let topPosition: LinePosition = hasHeader ? .middle : .top
    let topLine = horizontal(numberOfItems: info.numberOfItem, width: info.widthInfo, length: fullWidth, distribution: distribution, box: box, position: topPosition)
    print(topLine, to: &stream)
    result.append("\(topLine)\n")

    var row = "\(box.vertical)"
    for i in 0..<info.numberOfItem {
        let width = distribution == .fillProportionally ? (info.widthInfo[i] ?? 0) : info.maxWidth
        let stringValue = escapeControlCharacters(String(data[i]))
        let space = String(repeating: " ", count: max(0, width - stringValue.displayWidth))
        let item = "\(stringValue)\(space)\(box.vertical)"
        row += item
    }
    print(row, to: &stream)
    result.append("\(row)\n")

    // Bottom line
    let bottomLine = horizontal(numberOfItems: info.numberOfItem, width: info.widthInfo, length: fullWidth, distribution: distribution, box: box, position: .bottom)
    print(bottomLine, to: &stream)
    result.append("\(bottomLine)\n")
    return result
}

@discardableResult private func printTable<Item: LosslessStringConvertible, Stream: TextOutputStream>(
    data: [[Item]],
    info: (numberOfItem: Int, maxWidth: Int, widthInfo: [Int: Int]),
    distribution: TableSpacing,
    box: BoxCharacters,
    hasHeader: Bool,
    stream: inout Stream
) -> String {
    guard info.numberOfItem > 0, !data.isEmpty else { return "" }
    var result = ""
    let fullWidth = distribution == .fillProportionally ? info.widthInfo.reduce(0, { $0 + $1.value }) : info.maxWidth * info.numberOfItem

    for i in 0..<data.count {
        let isFirst = i == 0
        let isLast = i == data.count - 1

        // Top line (only if no header and first row)
        if isFirst && !hasHeader {
            let topLine = horizontal(numberOfItems: info.numberOfItem, width: info.widthInfo, length: fullWidth, distribution: distribution, box: box, position: .top)
            print(topLine, to: &stream)
            result.append("\(topLine)\n")
        } else if isFirst && hasHeader {
            // Separator after header
            let midLine = horizontal(numberOfItems: info.numberOfItem, width: info.widthInfo, length: fullWidth, distribution: distribution, box: box, position: .middle)
            print(midLine, to: &stream)
            result.append("\(midLine)\n")
        }

        var row = "\(box.vertical)"
        for j in 0..<info.numberOfItem {
            let hasItem = data[i].indices.contains(j)
            let width = distribution == .fillProportionally ? (info.widthInfo[j] ?? 0) : info.maxWidth

            if hasItem {
                let stringValue = escapeControlCharacters(String(data[i][j]))
                let spaceCount = max(0, width - stringValue.displayWidth)
                let space = String(repeating: " ", count: spaceCount)
                let item = "\(stringValue)\(space)\(box.vertical)"
                row += item
            } else {
                let space = String(repeating: " ", count: width)
                let item = "\(space)\(box.vertical)"
                row += item
            }
        }
        print(row, to: &stream)
        result.append("\(row)\n")

        // Bottom or middle line
        let linePosition: LinePosition = isLast ? .bottom : .middle
        let horizontalLine = horizontal(numberOfItems: info.numberOfItem, width: info.widthInfo, length: fullWidth, distribution: distribution, box: box, position: linePosition)
        print(horizontalLine, to: &stream)
        result.append("\(horizontalLine)\n")
    }
    return result
}

private func tableInfo(data: [AnyHashable: Any]) -> (
    numberOfItem: Int,
    maxKeyWidth: Int,
    maxValueWidth: Int,
    widthInfo: [String: Int]
    ) {
    guard !data.isEmpty else {
        return (numberOfItem: 2, maxKeyWidth: 0, maxValueWidth: 0, widthInfo: [:])
    }
    let valueData = data.compactMap { String(describing: $0.value) }
    let keyData = data.compactMap { String(describing: $0.key) }
    let maxValueWidth = valueData.map { $0.displayWidth }.max() ?? 0
    let maxKeyWidth = keyData.map { $0.displayWidth }.max() ?? 0
    var maxValueWidthDict: [String: Int] = [:]
    for key in keyData {
        maxValueWidthDict[key] = String(describing: data[key] ?? "").displayWidth
    }
    return (numberOfItem: 2, maxKeyWidth: maxKeyWidth, maxValueWidth: maxValueWidth, widthInfo: maxValueWidthDict)
}

private func tableInfo<Item: LosslessStringConvertible>(data: [Item]) -> (
    numberOfItem: Int,
    maxWidth: Int,
    widthInfo: [Int: Int]
    ) {
    guard !data.isEmpty else {
        return (numberOfItem: 0, maxWidth: 0, widthInfo: [:])
    }
    let stringData = data.map { String($0) }
    let maxWidth = stringData.map { $0.displayWidth }.max() ?? 0
    var maxWidthDict: [Int: Int] = [:]
    for (index, item) in stringData.enumerated() {
        maxWidthDict[index] = item.displayWidth
    }
    return (numberOfItem: stringData.count, maxWidth: maxWidth, widthInfo: maxWidthDict)
}

private func tableInfo<Item: LosslessStringConvertible>(data: [[Item]]) -> (
    numberOfItem: Int,
    maxWidth: Int,
    widthInfo: [Int: Int]
    ) {
    guard !data.isEmpty else {
        return (numberOfItem: 0, maxWidth: 0, widthInfo: [:])
    }
    let flattened = Array(data.joined())
    guard !flattened.isEmpty else {
        return (numberOfItem: 0, maxWidth: 0, widthInfo: [:])
    }
    let maxWidth = flattened.map { String($0).displayWidth }.max() ?? 0
    let itemCount = data.map { $0.count }.max() ?? 0
    var maxWidthDict: [Int: Int] = [:]

    for i in 0..<itemCount {
        if let items = data.column(index: i) {
            let stringData = items.map { String(describing: $0) }
            let maxCount = stringData.map { $0.displayWidth }.max() ?? 0
            maxWidthDict[i] = maxCount
        }
    }
    return (numberOfItem: itemCount, maxWidth: maxWidth, widthInfo: maxWidthDict)
}

@discardableResult private func horizontal(
    numberOfItems: Int,
    width: [Int: Int],
    length: Int,
    distribution: TableSpacing,
    box: BoxCharacters,
    position: LinePosition
) -> String {
    let maxWidth = Int(width.values.sorted(by: > ).first ?? 0)
    let horizontal = box.horizontal
    let leftCorner = box.leftCorner(for: position)
    let rightCorner = box.rightCorner(for: position)
    let junction = box.junction(for: position)

    var line = "\(leftCorner)"
    for i in 0..<numberOfItems {
        let cellWidth = distribution == .fillProportionally ? (width[i] ?? 0) : maxWidth
        line += String(repeating: horizontal, count: cellWidth)
        if i < numberOfItems - 1 {
            line += "\(junction)"
        }
    }
    line += "\(rightCorner)"
    return line
}


@discardableResult private func horizontal(
    numberOfItems: Int,
    keyWidth: Int,
    valueWidth: Int,
    distribution: TableSpacing,
    box: BoxCharacters,
    position: LinePosition
) -> String {
    let maxWidth = max(keyWidth, valueWidth)
    let horizontal = box.horizontal
    let leftCorner = box.leftCorner(for: position)
    let rightCorner = box.rightCorner(for: position)
    let junction = box.junction(for: position)

    var line = "\(leftCorner)"
    for i in 0..<numberOfItems {
        let cellWidth: Int
        if distribution == .fillProportionally {
            cellWidth = i == 0 ? keyWidth : valueWidth
        } else {
            cellWidth = maxWidth
        }
        line += String(repeating: horizontal, count: cellWidth)
        if i < numberOfItems - 1 {
            line += "\(junction)"
        }
    }
    line += "\(rightCorner)"
    return line
}

// From StackOverflow: Martin R's Answer
// https://stackoverflow.com/questions/35244584/get-column-from-2d-array-how-to-restrict-array-type-in-extension
private extension Array where Element : Collection {
    func column(index : Element.Index) -> [ Element.Iterator.Element ]? {
        let firstIndex = self.firstIndex(where: {$0.indices.contains(index)})
        if let _ = firstIndex {
            let filtered = self.filter { $0.indices.contains(index) }
            return filtered.map { $0[index] }
        }
        else {
            return nil
        }
    }
}
