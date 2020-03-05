//
//  Table.swift
//  print(table: [], header: [], terminator: "\n")
//
//  Created by BaekSungwook on 3/5/20.
//  Copyright © 2020 BaekSungwook. All rights reserved.
//

/// - Parameters:
///   - table: Zero or more items to print.
///   - header: A string to print header on table.
///   - terminator: A string to print end of function.
//public func print(table data: Any, header: [String]? = nil)
public func print(table data: Any, header: [String]? = nil, terminator: String = "") {
    let mirrorObj = Mirror(reflecting: data)
    if mirrorObj.subjectType == [String].self {
        let inputData = data as! [String]
        var info = tableInfo(data: inputData)
        if let header = header {
            assert(header.count == inputData.count, "header should be equal items")
            let headerInfo = tableInfo(data: header)
            info.maxWidth = max(info.maxWidth, headerInfo.maxWidth)
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
            let headerInfo = tableInfo(data: header)
            info.maxWidth = max(info.maxWidth, headerInfo.maxWidth)
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
            let headerInfo = tableInfo(data: header)
            info.maxWidth = max(info.maxWidth, headerInfo.maxWidth)
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
            let headerInfo = tableInfo(data: header)
            info.maxWidth = max(info.maxWidth, headerInfo.maxWidth)
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
            let headerInfo = tableInfo(data: header)
            info.maxWidth = max(info.maxWidth, headerInfo.maxWidth)
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
            let headerInfo = tableInfo(data: header)
            info.maxWidth = max(info.maxWidth, headerInfo.maxWidth)
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
            let headerInfo = tableInfo(data: header)
            info.maxWidth = max(info.maxWidth, headerInfo.maxWidth)
            print(header: header, info: info)
        }
        printTable(data: inputData, info: info)
        print(terminator)
    }
}

private func print(header: [String], info: (numberOfItem: Int, maxWidth: Int)) {
    let horizontalLine = horizontal(numberOfItems: info.numberOfItem, width: info.maxWidth)
    print(horizontalLine)
    var row = "|"
    for i in 0..<header.count {
        let space = String(repeating: " ", count: info.maxWidth - String(header[i]).count)
        let item = "\(header[i])\(space)|"
        row += item
    }
    print(row)
}

private func printTable(data: [AnyHashable: Any], info: (numberOfItem: Int, maxWidth: Int)) {
    let horizontalLine = horizontal(numberOfItems: info.numberOfItem, width: info.maxWidth)
    print(horizontalLine)
    
    for key in data.keys {
        var row = "|"
        let keyValue = String(describing: key)
        let keySpace = String(repeating: " ", count: info.maxWidth - keyValue.count)
        let keyItem = "\(keyValue)\(keySpace)|"
        row += keyItem
        let value = String(describing: data[key] ?? "")
        let space = String(repeating: " ", count: info.maxWidth - value.count)
        let item = "\(value)\(space)|"
        row += item
        print(row)
        print(horizontalLine)
    }
}

private func printTable<Item: LosslessStringConvertible>(data: [Item], info: (numberOfItem: Int, maxWidth: Int)) {
    let horizontalLine = horizontal(numberOfItems: info.numberOfItem, width: info.maxWidth)
    print(horizontalLine)
    var row = "|"
    for i in 0..<info.numberOfItem {
        let space = String(repeating: " ", count: info.maxWidth - String(data[i]).count)
        let item = "\(data[i])\(space)|"
        row += item
    }
    print(row)
    print(horizontalLine)
}

private func printTable<Item: LosslessStringConvertible>(data: [[Item]], info: (numberOfItem: Int, maxWidth: Int)) {
    let horizontalLine = horizontal(numberOfItems: info.numberOfItem, width: info.maxWidth)
    print(horizontalLine)
    for i in 0..<data.count {
        var row = "|"
        for j in 0..<info.numberOfItem {
            let hasItem = data[i].indices.contains(j)
            let spaceCount = hasItem ? (info.maxWidth - String(data[i][j]).count) : info.maxWidth
            let space = String(repeating: " ", count: spaceCount)
            let item = hasItem ? "\(data[i][j])\(space)|" : "\(space)|"
            row += item
        }
        print(row)
        print(horizontalLine)
    }
}

private func tableInfo(data: [AnyHashable: Any]) -> (numberOfItem: Int, maxWidth: Int) {
    let valueData = data.compactMap { String(describing: $0.value) }
    let keyData = data.compactMap { String(describing: $0.key) }
    let maxValueWidth = valueData.sorted { $0.count > $1.count }.first!.count
    let maxKeyWidth = keyData.sorted { $0.count > $1.count }.first!.count
    return (numberOfItem: 2, maxWidth: max(maxValueWidth, maxKeyWidth))
}

private func tableInfo<Item: LosslessStringConvertible>(data: [Item]) -> (numberOfItem: Int, maxWidth: Int) {
    let stringData = data.map { String($0) }
    let maxWidth = stringData.sorted { $0.count > $1.count }.first!.count
    return (numberOfItem: stringData.count, maxWidth: maxWidth)
}

private func tableInfo<Item: LosslessStringConvertible>(data: [[Item]]) -> (numberOfItem: Int, maxWidth: Int) {
    let flattened = Array(data.joined())
    let maxWidth = String(flattened.sorted { String($0).count > String($1).count }.first!).count
    let itemCount = data.sorted{ $0.count > $1.count }.first!.count
    return (numberOfItem: itemCount, maxWidth: maxWidth)
}

private func horizontal(numberOfItems: Int, width: Int) -> String {
    var line = String(repeating: "-", count: numberOfItems * width)
    line.insert("+", at: line.startIndex)
    for _ in 0..<numberOfItems {
        if let index = line.lastIndex(of: "+") {
            let nextStarIndex = line.index(index, offsetBy: width + 1)
            line.insert("+", at: nextStarIndex)
        }
    }
    return line
}
