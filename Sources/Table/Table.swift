//
//  Table.swift
//  print(table: [], header: [], terminator: "\n")
//
//  Created by BaekSungwook on 3/5/20.
//  Copyright © 2020 BaekSungwook. All rights reserved.
//

// Extension to handle Unicode character width properly
extension String {
    /// Calculate the display width of the string
    /// CJK characters and other full-width characters count as 2 spaces
    var displayWidth: Int {
        return self.reduce(0) { $0 + $1.displayWidth }
    }
}

extension Character {
    /// Calculate the display width of a character
    /// CJK characters and other full-width characters count as 2 spaces
    var displayWidth: Int {
        // ASCII characters (most English letters, numbers, basic symbols)
        if self.isASCII {
            return 1
        }
        
        // Check for CJK and other full-width characters
        let unicodeScalars = self.unicodeScalars
        let value = unicodeScalars[unicodeScalars.startIndex].value
        
        // CJK character ranges and full-width character ranges
        if (0x1100...0x11FF).contains(value) ||    // Hangul Jamo
           (0x2E80...0x9FFF).contains(value) ||    // CJK Unified Ideographs
           (0xAC00...0xD7AF).contains(value) ||    // Hangul Syllables
           (0xF900...0xFAFF).contains(value) ||    // CJK Compatibility Ideographs
           (0xFF01...0xFF60).contains(value) {     // Full-width ASCII variants
            return 2
        }
        
        // Other Unicode characters default to width 1
        return 1
    }
}

public enum TableSpacing {
    case fillProportionally
    case fillEqually
}

/// Print data in table format
/// - Parameters:
///   - table: Zero or more items to print.
///   - header: A string to print header on table.
///   - terminator: A string to print end of function.
///   - distribution: A spacing for item
@discardableResult public func print(
    table data: Any,
    header: [String]? = nil,
    distribution: TableSpacing = .fillProportionally,
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
        terminator: terminator,
        stream: &defaultStream
    )
}

@discardableResult public func print<Stream: TextOutputStream>(
    table data: Any,
    header: [String]? = nil,
    distribution: TableSpacing = .fillProportionally,
    terminator: String = "",
    stream: inout Stream
) -> String {
    var result = ""
    let mirrorObj = Mirror(reflecting: data)
    if mirrorObj.subjectType == [String].self {
        let inputData = data as! [String]
        var info = tableInfo(data: inputData)
        if let header = header {
            assert(header.count == inputData.count, "header should be equal items")
            for (index, title) in header.enumerated() {
                let infoWidth = info.widthInfo[index]!
                info.widthInfo[index] = max(infoWidth, title.displayWidth)
            }
            result.append(print(header: header, info: info, distribution: distribution, stream: &stream))
        }
        result.append(printTable(data: inputData, info: info, distribution: distribution, stream: &stream))
        print(terminator, to: &stream)
        result.append(terminator)
    }
    else if mirrorObj.subjectType == [Int].self {
        let inputData = data as! [Int]
        var info = tableInfo(data: inputData)
        if let header = header {
            assert(header.count == inputData.count, "header should be equal items")
            for (index, title) in header.enumerated() {
                let infoWidth = info.widthInfo[index]!
                info.widthInfo[index] = max(infoWidth, title.displayWidth)
            }
            result.append(print(header: header, info: info, distribution: distribution, stream: &stream))
        }
        result.append(printTable(data: inputData, info: info, distribution: distribution, stream: &stream))
        print(terminator, to: &stream)
        result.append(terminator)
    }
    else if mirrorObj.subjectType == [Double].self {
        let inputData = data as! [Double]
        var info = tableInfo(data: inputData)
        if let header = header {
            assert(header.count == inputData.count, "header should be equal items")
            for (index, title) in header.enumerated() {
                let infoWidth = info.widthInfo[index]!
                info.widthInfo[index] = max(infoWidth, title.displayWidth)
            }
            result.append(print(header: header, info: info, distribution: distribution, stream: &stream))
        }
        result.append(printTable(data: inputData, info: info, distribution: distribution, stream: &stream))
        print(terminator, to: &stream)
        result.append(terminator)
    }
    else if mirrorObj.subjectType == [AnyHashable: Any].self {
        let inputData = data as! [AnyHashable: Any]
        var info = tableInfo(data: inputData)
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
            result.append(print(header: header, info: info, distribution: distribution, stream: &stream))
        }
        result.append(printTable(data: inputData, info: info, distribution: distribution, stream: &stream))
        print(terminator, to: &stream)
        result.append(terminator)
    }
    else if mirrorObj.subjectType == [[String]].self {
        let inputData = data as! [[String]]
        var info = tableInfo(data: inputData)
        if let header = header {
            assert(inputData.map({ $0.count }).max() == header.count, "header should be equal items")
            for (index, title) in header.enumerated() {
                let infoWidth = info.widthInfo[index]!
                info.widthInfo[index] = max(infoWidth, title.displayWidth)
            }
            result.append(print(header: header, info: info, distribution: distribution, stream: &stream))
        }
        result.append(printTable(data: inputData, info: info, distribution: distribution, stream: &stream))
        print(terminator, to: &stream)
        result.append(terminator)
    }
    else if mirrorObj.subjectType == [[Int]].self {
        let inputData = data as! [[Int]]
        var info = tableInfo(data: inputData)
        if let header = header {
            assert(inputData.map({ $0.count }).max() == header.count, "header should be equal items")
            for (index, title) in header.enumerated() {
                let infoWidth = info.widthInfo[index]!
                info.widthInfo[index] = max(infoWidth, title.displayWidth)
            }
            result.append(print(header: header, info: info, distribution: distribution, stream: &stream))
        }
        result.append(printTable(data: inputData, info: info, distribution: distribution, stream: &stream))
        print(terminator, to: &stream)
        result.append(terminator)
    }
    else if mirrorObj.subjectType == [[Double]].self {
        let inputData = data as! [[Double]]
        var info = tableInfo(data: inputData)
        if let header = header {
            assert(inputData.map({ $0.count }).max() == header.count, "header should be equal items")
            for (index, title) in header.enumerated() {
                let infoWidth = info.widthInfo[index]!
                info.widthInfo[index] = max(infoWidth, title.displayWidth)
            }
            result.append(print(header: header, info: info, distribution: distribution, stream: &stream))
        }
        result.append(printTable(data: inputData, info: info, distribution: distribution, stream: &stream))
        print(terminator, to: &stream)
        result.append(terminator)
    }
    return result
}

@discardableResult private func print<Stream: TextOutputStream>(
    header: [String],
    info: (numberOfItem: Int, maxWidth: Int, widthInfo: [Int: Int]),
    distribution: TableSpacing,
    stream: inout Stream
) -> String {
    var result = ""
    let fullWidth = distribution == .fillProportionally ? info.widthInfo.reduce(0, { $0 + $1.value }) : info.maxWidth * info.numberOfItem
    let horizontalLine = horizontal(numberOfItems: info.numberOfItem, width: info.widthInfo, length: fullWidth, distribution: distribution)
    print(horizontalLine, to: &stream)
    result.append("\(horizontalLine)\n")
    var row = "|"
    for i in 0..<header.count {
        let width = distribution == .fillProportionally ? info.widthInfo[i]! : info.maxWidth
        let space = String(repeating: " ", count: width - header[i].displayWidth)
        let item = "\(header[i])\(space)|"
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
    stream: inout Stream
) -> String {
    var result = ""
    let horizontalLine = horizontal(numberOfItems: info.numberOfItem, keyWidth: info.maxKeyWidth, valueWidth: info.maxValueWidth, distribution: distribution)
    print(horizontalLine, to: &stream)
    result.append("\(horizontalLine)\n")
    var row = "|"
    for i in 0..<header.count {
        var itemCount = 0
        if distribution == .fillProportionally {
            itemCount = i == 0 ? info.maxKeyWidth : info.maxValueWidth
        }
        else {
            itemCount = max(info.maxKeyWidth, info.maxValueWidth)
        }
        let space = String(repeating: " ", count: itemCount - header[i].displayWidth)
        let item = "\(header[i])\(space)|"
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
    stream: inout Stream
) -> String {
    var result = ""
    let horizontalLine = horizontal(
        numberOfItems: info.numberOfItem,
        keyWidth: info.maxKeyWidth,
        valueWidth: info.maxValueWidth, distribution: distribution
    )
    print(horizontalLine, to: &stream)
    result.append("\(horizontalLine)\n")
    let maxWidth = max(info.maxKeyWidth, info.maxValueWidth)
    for key in data.keys {
        var row = "|"
        let keyValue = String(describing: key)
        let keyWidth = distribution == .fillProportionally ? info.maxKeyWidth : maxWidth
        let keySpace = String(repeating: " ", count: keyWidth - keyValue.displayWidth)
        let keyItem = "\(keyValue)\(keySpace)|"
        row += keyItem
        let value = String(describing: data[key] ?? "")
        let valueWidth = distribution == .fillProportionally ? info.maxValueWidth : maxWidth
        let space = String(repeating: " ", count: valueWidth - value.displayWidth)
        let item = "\(value)\(space)|"
        row += item
        print(row, to: &stream)
        print(horizontalLine, to: &stream)
        result.append("\(row)\n")
        result.append("\(horizontalLine)\n")
    }
    return result
}

@discardableResult private func printTable<Item: LosslessStringConvertible, Stream: TextOutputStream>(
    data: [Item],
    info: (numberOfItem: Int, maxWidth: Int, widthInfo: [Int: Int]),
    distribution: TableSpacing,
    stream: inout Stream
) -> String {
    var result = ""
    let fullWidth = distribution == .fillProportionally ? info.widthInfo.reduce(0, { $0 + $1.value }) : info.maxWidth * info.numberOfItem
    let horizontalLine = horizontal(numberOfItems: info.numberOfItem, width: info.widthInfo, length: fullWidth, distribution: distribution)
    print(horizontalLine, to: &stream)
    result.append("\(horizontalLine)\n")
    var row = "|"
    for i in 0..<info.numberOfItem {
        let width = distribution == .fillProportionally ? info.widthInfo[i]! : info.maxWidth
        let stringValue = String(data[i])
        let space = String(repeating: " ", count: width - stringValue.displayWidth)
        let item = "\(stringValue)\(space)|"
        row += item
    }
    print(row, to: &stream)
    print(horizontalLine, to: &stream)
    result.append("\(row)\n")
    result.append("\(horizontalLine)\n")
    return result
}

@discardableResult private func printTable<Item: LosslessStringConvertible, Stream: TextOutputStream>(
    data: [[Item]],
    info: (numberOfItem: Int, maxWidth: Int, widthInfo: [Int: Int]),
    distribution: TableSpacing,
    stream: inout Stream
) -> String {
    var result = ""
    let fullWidth = distribution == .fillProportionally ? info.widthInfo.reduce(0, { $0 + $1.value }) : info.maxWidth * info.numberOfItem
    let horizontalLine = horizontal(numberOfItems: info.numberOfItem, width: info.widthInfo, length: fullWidth, distribution: distribution)
    print(horizontalLine, to: &stream)
    result.append("\(horizontalLine)\n")
    for i in 0..<data.count {
        var row = "|"
        for j in 0..<info.numberOfItem {
            let hasItem = data[i].indices.contains(j)
            let width = distribution == .fillProportionally ? info.widthInfo[j]! : info.maxWidth
            
            if hasItem {
                let stringValue = String(data[i][j])
                let spaceCount = width - stringValue.displayWidth
                let space = String(repeating: " ", count: spaceCount)
                let item = "\(stringValue)\(space)|"
                row += item
            } else {
                let space = String(repeating: " ", count: width)
                let item = "\(space)|"
                row += item
            }
        }
        print(row, to: &stream)
        print(horizontalLine, to: &stream)
        result.append("\(row)\n")
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
    let valueData = data.compactMap { String(describing: $0.value) }
    let keyData = data.compactMap { String(describing: $0.key) }
    let maxValueWidth = valueData.sorted { $0.displayWidth > $1.displayWidth }.first!.displayWidth
    let maxKeyWidth = keyData.sorted { $0.displayWidth > $1.displayWidth }.first!.displayWidth
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
    let stringData = data.map { String($0) }
    let maxWidth = stringData.sorted { $0.displayWidth > $1.displayWidth }.first!.displayWidth
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
    let flattened = Array(data.joined())
    let maxWidth = String(flattened.sorted { String($0).displayWidth > String($1).displayWidth }.first!).displayWidth
    let itemCount = data.sorted{ $0.count > $1.count }.first!.count
    var maxWidthDict: [Int: Int] = [:]

    for i in 0..<itemCount {
        if let items = data.column(index: i) {
            let stringData = items.map {String(describing: $0)}
            let maxCount = stringData.sorted{ $0.displayWidth > $1.displayWidth }.first!.displayWidth
            maxWidthDict[i] = maxCount
        }
    }
    return (numberOfItem: itemCount, maxWidth: maxWidth, widthInfo: maxWidthDict)
}

@discardableResult private func horizontal(
    numberOfItems: Int,
    width: [Int: Int],
    length: Int,
    distribution: TableSpacing
) -> String {
    let maxWidth = Int(width.values.sorted(by: > ).first ?? 0)
    var line = String(repeating: "-", count: length)
    line.insert("+", at: line.startIndex)
    for i in 0..<numberOfItems {
        if let index = line.lastIndex(of: "+") {
            let offset = distribution == .fillProportionally ? width[i]! : maxWidth
            let nextStarIndex = line.index(index, offsetBy: offset + 1)
            line.insert("+", at: nextStarIndex)
        }
    }
    return line
}


@discardableResult private func horizontal(
    numberOfItems: Int,
    keyWidth: Int,
    valueWidth: Int,
    distribution: TableSpacing
) -> String {
    let maxWidth = max(keyWidth, valueWidth)
    var line = distribution == .fillProportionally ?
        String(repeating: "-", count: keyWidth + valueWidth) :
        String(repeating: "-", count: maxWidth * 2)

    line.insert("+", at: line.startIndex)
    for i in 0..<numberOfItems {
        if let index = line.lastIndex(of: "+") {
            var offset = 0
            if distribution == .fillProportionally {
                offset = i == 0 ? keyWidth : valueWidth
            }
            else {
                offset = maxWidth
            }
            let nextStarIndex = line.index(index, offsetBy: offset + 1)
            line.insert("+", at: nextStarIndex)
        }
    }
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
