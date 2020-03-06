//
//  Table.swift
//  print(table: [], header: [], terminator: "\n")
//
//  Created by BaekSungwook on 3/5/20.
//  Copyright © 2020 BaekSungwook. All rights reserved.
//

//TODO:- Support Spacing Option
public enum TableSpacing {
    case fill
    case fillEqually
}
/// - Parameters:
///   - table: Zero or more items to print.
///   - header: A string to print header on table.
///   - terminator: A string to print end of function.
//public func print(table data: Any, header: [String]? = nil)
public func print(
    table data: Any,
    header: [String]? = nil,
    spacing: TableSpacing = .fill,
    terminator: String = ""
) {
    let mirrorObj = Mirror(reflecting: data)
    if mirrorObj.subjectType == [String].self {
        let inputData = data as! [String]
        var info = tableInfo(data: inputData)
        if let header = header {
            assert(header.count == inputData.count, "header should be equal items")
            for (index, title) in header.enumerated() {
                let infoWidth = info.widthInfo[index]!
                info.widthInfo[index] = max(infoWidth, title.count)
            }
            print(header: header, info: info)
        }
        printTable(data: inputData, info: info)
        print(terminator)
    }
    else if mirrorObj.subjectType == [Int].self {
        let inputData = data as! [Int]
        var info = tableInfo(data: inputData)
        if let header = header {
            assert(header.count == inputData.count, "header should be equal items")
            for (index, title) in header.enumerated() {
                let infoWidth = info.widthInfo[index]!
                info.widthInfo[index] = max(infoWidth, title.count)
            }
            print(header: header, info: info)
        }
        printTable(data: inputData, info: info)
        print(terminator)
    }
    else if mirrorObj.subjectType == [Double].self {
        let inputData = data as! [Double]
        var info = tableInfo(data: inputData)
        if let header = header {
            assert(header.count == inputData.count, "header should be equal items")
            for (index, title) in header.enumerated() {
                let infoWidth = info.widthInfo[index]!
                info.widthInfo[index] = max(infoWidth, title.count)
            }
            print(header: header, info: info)
        }
        printTable(data: inputData, info: info)
        print(terminator)
    }
    else if mirrorObj.subjectType == [AnyHashable: Any].self {
        let inputData = data as! [AnyHashable: Any]
        var info = tableInfo(data: inputData)
        if let header = header {
            assert(header.count == 2, "header should be key, value for dictionary")
            for (index, title) in header.enumerated() {
                if index == 0 {
                    info.maxKeyWidth = max(info.maxKeyWidth, title.count)
                }
                else {
                    info.maxValueWidth = max(info.maxValueWidth, title.count)
                }
            }
            print(header: header, info: info)
        }
        printTable(data: inputData, info: info)
        print(terminator)
    }
    else if mirrorObj.subjectType == [[String]].self {
        let inputData = data as! [[String]]
        var info = tableInfo(data: inputData)
        if let header = header {
            assert(header.count == inputData.count, "header should be equal items")
            for (index, title) in header.enumerated() {
                let infoWidth = info.widthInfo[index]!
                info.widthInfo[index] = max(infoWidth, title.count)
            }
            print(header: header, info: info)
        }
        printTable(data: inputData, info: info)
        print(terminator)
    }
    else if mirrorObj.subjectType == [[Int]].self {
        let inputData = data as! [[Int]]
        var info = tableInfo(data: inputData)
        if let header = header {
            assert(header.count == inputData.count, "header should be equal items")
            for (index, title) in header.enumerated() {
                let infoWidth = info.widthInfo[index]!
                info.widthInfo[index] = max(infoWidth, title.count)
            }
            print(header: header, info: info)
        }
        printTable(data: inputData, info: info)
        print(terminator)
    }
    else if mirrorObj.subjectType == [[Double]].self {
        let inputData = data as! [[Double]]
        var info = tableInfo(data: inputData)
        if let header = header {
            assert(header.count == inputData.count, "header should be equal items")
            for (index, title) in header.enumerated() {
                let infoWidth = info.widthInfo[index]!
                info.widthInfo[index] = max(infoWidth, title.count)
            }
            print(header: header, info: info)
        }
        printTable(data: inputData, info: info)
        print(terminator)
    }
}

private func print(
    header: [String],
    info: (numberOfItem: Int, maxWidth: Int, widthInfo: [Int: Int])
) {
    let fullWidth = info.widthInfo.reduce(0, { $0 + $1.value })
    let horizontalLine = horizontal(
        numberOfItems: info.numberOfItem,
        width: info.widthInfo,
        length: fullWidth
    )
    print(horizontalLine)
    var row = "|"
    for i in 0..<header.count {
        let space = String(repeating: " ", count: info.widthInfo[i]! - String(header[i]).count)
        let item = "\(header[i])\(space)|"
        row += item
    }
    print(row)
}

private func print(
    header: [String],
    info: (numberOfItem: Int, maxKeyWidth: Int, maxValueWidth: Int, widthInfo: [String: Int])
) {
    let horizontalLine = horizontal(
        numberOfItems: info.numberOfItem,
        keyWidth: info.maxKeyWidth,
        valueWidth: info.maxValueWidth
    )
    print(horizontalLine)
    var row = "|"
    for i in 0..<header.count {
        let itemCount = i == 0 ? info.maxKeyWidth : info.maxValueWidth
        let space = String(repeating: " ", count: itemCount - String(header[i]).count)
        let item = "\(header[i])\(space)|"
        row += item
    }
    print(row)
}

private func printTable(
    data: [AnyHashable: Any],
    info: (numberOfItem: Int, maxKeyWidth: Int, maxValueWidth: Int, widthInfo: [String : Int])
) {
    let horizontalLine = horizontal(
        numberOfItems: info.numberOfItem,
        keyWidth: info.maxKeyWidth,
        valueWidth: info.maxValueWidth
    )
    print(horizontalLine)

    for key in data.keys {
        var row = "|"
        let keyValue = String(describing: key)
        let keySpace = String(repeating: " ", count: info.maxKeyWidth - keyValue.count)
        let keyItem = "\(keyValue)\(keySpace)|"
        row += keyItem
        let value = String(describing: data[key] ?? "")
        let space = String(repeating: " ", count: info.maxValueWidth - value.count)
        let item = "\(value)\(space)|"
        row += item
        print(row)
        print(horizontalLine)
    }
}

private func printTable<Item: LosslessStringConvertible>(
    data: [Item],
    info: (numberOfItem: Int, maxWidth: Int, widthInfo: [Int: Int])) {
    let fullWidth = info.widthInfo.reduce(0, { $0 + $1.value })
    let horizontalLine = horizontal(
        numberOfItems: info.numberOfItem,
        width: info.widthInfo,
        length: fullWidth
    )
    print(horizontalLine)
    var row = "|"
    for i in 0..<info.numberOfItem {
        let space = String(repeating: " ", count: info.widthInfo[i]! - String(data[i]).count)
        let item = "\(data[i])\(space)|"
        row += item
    }
    print(row)
    print(horizontalLine)
}

private func printTable<Item: LosslessStringConvertible>(
    data: [[Item]],
    info: (numberOfItem: Int, maxWidth: Int, widthInfo: [Int: Int])
) {
    let fullWidth = info.widthInfo.reduce(0, { $0 + $1.value })
    let horizontalLine = horizontal(
        numberOfItems: info.numberOfItem,
        width: info.widthInfo,
        length: fullWidth
    )
    print(horizontalLine)
    for i in 0..<data.count {
        var row = "|"
        for j in 0..<info.numberOfItem {
            let hasItem = data[i].indices.contains(j)
            let spaceCount = hasItem ? (info.widthInfo[j]! - String(data[i][j]).count) : info.widthInfo[j]!
            let space = String(repeating: " ", count: spaceCount)
            let item = hasItem ? "\(data[i][j])\(space)|" : "\(space)|"
            row += item
        }
        print(row)
        print(horizontalLine)
    }
}

private func tableInfo(data: [AnyHashable: Any]) -> (
    numberOfItem: Int,
    maxKeyWidth: Int,
    maxValueWidth: Int,
    widthInfo: [String: Int]
    ) {
    let valueData = data.compactMap { String(describing: $0.value) }
    let keyData = data.compactMap { String(describing: $0.key) }
    let maxValueWidth = valueData.sorted { $0.count > $1.count }.first!.count
    let maxKeyWidth = keyData.sorted { $0.count > $1.count }.first!.count
    var maxValueWidthDict: [String: Int] = [:]
    for key in keyData {
        maxValueWidthDict[key] = String(describing: data[key] ?? "").count
    }
    return (numberOfItem: 2, maxKeyWidth: maxKeyWidth, maxValueWidth: maxValueWidth, widthInfo: maxValueWidthDict)
}

private func tableInfo<Item: LosslessStringConvertible>(data: [Item]) -> (
    numberOfItem: Int,
    maxWidth: Int,
    widthInfo: [Int: Int]
    ) {
    let stringData = data.map { String($0) }
    let maxWidth = stringData.sorted { $0.count > $1.count }.first!.count
    var maxWidthDict: [Int: Int] = [:]
    for (index, item) in stringData.enumerated() {
        maxWidthDict[index] = item.count
    }
    return (numberOfItem: stringData.count, maxWidth: maxWidth, widthInfo: maxWidthDict)
}

private func tableInfo<Item: LosslessStringConvertible>(data: [[Item]]) -> (
    numberOfItem: Int,
    maxWidth: Int,
    widthInfo: [Int: Int]
    ) {
    let flattened = Array(data.joined())
    let maxWidth = String(flattened.sorted { String($0).count > String($1).count }.first!).count
    let itemCount = data.sorted{ $0.count > $1.count }.first!.count
    var maxWidthDict: [Int: Int] = [:]
        
    for i in 0..<itemCount {
        if let items = data.column(index: i) {
            let stringData = items.map {String(describing: $0)}
            let maxCount = stringData.sorted{ $0.count > $1.count }.first!.count
            maxWidthDict[i] = maxCount
        }
    }
    return (numberOfItem: itemCount, maxWidth: maxWidth, widthInfo: maxWidthDict)
}

private func horizontal(numberOfItems: Int, width: [Int: Int], length: Int) -> String {
    var line = String(repeating: "-", count: length)
    line.insert("+", at: line.startIndex)
    for i in 0..<numberOfItems {
        if let index = line.lastIndex(of: "+") {
            let nextStarIndex = line.index(index, offsetBy: width[i]! + 1)
            line.insert("+", at: nextStarIndex)
        }
    }
    return line
}


private func horizontal(numberOfItems: Int, keyWidth: Int, valueWidth: Int) -> String {
    var line = String(repeating: "-", count: keyWidth + valueWidth)
    line.insert("+", at: line.startIndex)
    for i in 0..<numberOfItems {
        if let index = line.lastIndex(of: "+") {
            let offset = i == 0 ? keyWidth : valueWidth
            let nextStarIndex = line.index(index, offsetBy: offset + 1)
            line.insert("+", at: nextStarIndex)
        }
    }
    return line
}

//StackOverflow: Martin R's Answer
//https://stackoverflow.com/questions/35244584/get-column-from-2d-array-how-to-restrict-array-type-in-extension
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
