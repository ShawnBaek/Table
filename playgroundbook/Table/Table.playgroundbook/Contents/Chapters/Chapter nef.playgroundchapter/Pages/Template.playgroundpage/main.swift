//#-hidden-code
import UIKit
import PlaygroundSupport
import Foundation

public let liveStackView = UIStackView()
liveStackView.spacing = 10
liveStackView.axis = .vertical

private func pin(view: UIView, to: UIView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        view.leadingAnchor.constraint(equalTo: to.leadingAnchor),
        view.topAnchor.constraint(equalTo: to.topAnchor),
        view.trailingAnchor.constraint(equalTo: to.trailingAnchor),
        view.bottomAnchor.constraint(equalTo: to.bottomAnchor)
    ])
}

let liveView = UIView()
let scrollView = UIScrollView()
scrollView.backgroundColor = .black
liveView.addSubview(scrollView)
pin(view: scrollView, to: liveView)

let stack = UIStackView()
scrollView.addSubview(stack)
stack.spacing = 30
stack.alignment = .leading
stack.distribution = .fillProportionally
stack.axis = .vertical
pin(view: stack, to: scrollView)

let background = UIView()
background.backgroundColor = .black
stack.insertSubview(background, at: 0)
pin(view: background, to: stack)

PlaygroundPage.current.liveView = liveView
PlaygroundPage.current.needsIndefiniteExecution = true

enum PlaygroundColor {
    static let nef = UIColor(red: 140/255.0, green: 68/255.0, blue: 1, alpha: 1)
    static let bow = UIColor(red: 213/255.0, green: 64/255.0, blue: 72/255.0, alpha: 1)
    static let white = UIColor.white
    static let black = UIColor.black
    static let yellow = UIColor(red: 1, green: 237/255.0, blue: 117/255.0, alpha: 1)
    static let green = UIColor(red: 110/255.0, green: 240/255.0, blue: 167/255.0, alpha: 1)
    static let blue = UIColor(red: 66/255.0, green: 197/255.0, blue: 1, alpha: 1)
    static let orange = UIColor(red: 1, green: 159/255.0, blue: 70/255.0, alpha: 1)
}

enum PlaygroundLog {
    static var log: String {
        guard let assessmentStatus = PlaygroundPage.current.assessmentStatus else { return "" }

        switch assessmentStatus {
        case let .pass(message): return message ?? ""
        default: return ""
        }
    }

    static func print(_ message: Any, clearAfter seconds: Int = 0) {
        let newMessage = "◦ \(message)"
        let assessmentStatus = log.isEmpty ? newMessage : "\(log)\n\n\(newMessage)"
        PlaygroundPage.current.assessmentStatus = .pass(message: assessmentStatus)
        if (seconds > 0) { PlaygroundLog.clear(after: seconds) }
    }

    static func clear(after seconds: Int = 0) {
        guard seconds > 0 else {
            PlaygroundPage.current.assessmentStatus = nil; return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds)) {
            PlaygroundPage.current.assessmentStatus = nil
        }
    }
}

public enum TableSpacing {
    case fillProportionally
    case fillEqually
}

/// - Parameters:
///  - table: Zero or more items to print.
///  - header: A string to print header on table.
///  - terminator: A string to print end of function.
//public func print(table data: Any, header: [String]? = nil)
public func print(
    table data: Any,
    header: [String]? = nil,
    distribution: TableSpacing = .fillProportionally,
    terminator: String = ""
) -> UIStackView {
    let stackView = UIStackView()
    stackView.spacing = 4
    stackView.axis = .vertical
    stackView.distribution = .fillProportionally
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
            stackView.addArrangedSubview(print(header: header, info: info, distribution: distribution))
        }
        stackView.addArrangedSubview(printTable(data: inputData, info: info, distribution: distribution))
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
            stackView.addArrangedSubview(print(header: header, info: info, distribution: distribution))
        }
        stackView.addArrangedSubview(printTable(data: inputData, info: info, distribution: distribution))
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
            stackView.addArrangedSubview(print(header: header, info: info, distribution: distribution))
        }
        stackView.addArrangedSubview(printTable(data: inputData, info: info, distribution: distribution))
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
            stackView.addArrangedSubview(print(header: header, info: info, distribution: distribution))
        }
        stackView.addArrangedSubview(printTable(data: inputData, info: info, distribution: distribution))
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
            stackView.addArrangedSubview(print(header: header, info: info, distribution: distribution))
        }
        stackView.addArrangedSubview(printTable(data: inputData, info: info, distribution: distribution))
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
            stackView.addArrangedSubview(print(header: header, info: info, distribution: distribution))
        }
        stackView.addArrangedSubview(printTable(data: inputData, info: info, distribution: distribution))
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
            stackView.addArrangedSubview(print(header: header, info: info, distribution: distribution))
        }
        stackView.addArrangedSubview(printTable(data: inputData, info: info, distribution: distribution))
    }
    stack.addArrangedSubview(stackView)
    return stackView
}

@discardableResult private func print(
    header: [String],
    info: (numberOfItem: Int, maxWidth: Int, widthInfo: [Int: Int]),
    distribution: TableSpacing
) -> UIStackView {
    let stackView = UIStackView()
    stackView.spacing = 4
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fillEqually
    for i in 0..<header.count {
        let label = UILabel()
        label.backgroundColor = .systemPink
        label.textColor = .white
        stackView.addArrangedSubview(label)
        label.text = "\(header[i])"
    }
    return stackView
}

@discardableResult private func print(
    header: [String],
    info: (numberOfItem: Int, maxKeyWidth: Int, maxValueWidth: Int, widthInfo: [String: Int]),
    distribution: TableSpacing
) -> UIStackView {
    let stackView = UIStackView()
    stackView.spacing = 4
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fillEqually
    for i in 0..<header.count {
        let label = UILabel()
        label.backgroundColor = .systemPink
        label.textColor = .white
        stackView.addArrangedSubview(label)
        label.text = "\(header[i])"
    }
    return stackView
}

@discardableResult private func printTable(
    data: [AnyHashable: Any],
    info: (numberOfItem: Int, maxKeyWidth: Int, maxValueWidth: Int, widthInfo: [String : Int]),
    distribution: TableSpacing
) -> UIStackView {
    let stackView = UIStackView()
    stackView.spacing = 4
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    for key in data.keys {
        let hStackView = UIStackView()
        hStackView.spacing = 4
        hStackView.axis = .horizontal
        hStackView.alignment = .center
        hStackView.distribution = .fillEqually
        
        let keyValue = String(describing: key)
        let keyLabel = UILabel()
        keyLabel.backgroundColor = .white
        keyLabel.textColor = .black
        hStackView.addArrangedSubview(keyLabel)
        keyLabel.text = keyValue
        
        let value = String(describing: data[key] ?? "")
        let valueLabel = UILabel()
        valueLabel.backgroundColor = .white
        valueLabel.textColor = .black
        hStackView.addArrangedSubview(valueLabel)
        valueLabel.text = value
        
        stackView.addArrangedSubview(hStackView)
    }
    return stackView
}

@discardableResult private func printTable<Item: LosslessStringConvertible>(
    data: [Item],
    info: (numberOfItem: Int, maxWidth: Int, widthInfo: [Int: Int]),
    distribution: TableSpacing) -> UIStackView {
    let stackView = UIStackView()
    stackView.spacing = 4
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fillEqually
    for i in 0..<info.numberOfItem {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        stackView.addArrangedSubview(label)
        label.text = "\(data[i])"
    }
    return stackView
}

@discardableResult private func printTable<Item: LosslessStringConvertible>(
    data: [[Item]],
    info: (numberOfItem: Int, maxWidth: Int, widthInfo: [Int: Int]),
    distribution: TableSpacing
) -> UIStackView {
    let stackView = UIStackView()
    stackView.spacing = 4
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    for i in 0..<data.count {
        let hStackView = UIStackView()
        hStackView.spacing = 4
        hStackView.axis = .horizontal
        hStackView.alignment = .fill
        hStackView.distribution = .fillEqually
        for j in 0..<info.numberOfItem {
            let hasItem = data[i].indices.contains(j)
            if hasItem {
                let label = UILabel()
                label.backgroundColor = .white
                label.textColor = .black
                hStackView.addArrangedSubview(label)
                label.text = "\(data[i][j])"
            }
            else {
                let label = UILabel()
                label.backgroundColor = .white
                label.textColor = .black
                label.text = " "
                hStackView.addArrangedSubview(label)
            }
        }
        stackView.addArrangedSubview(hStackView)
    }
    return stackView
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


PlaygroundLog.clear()
//#-end-hidden-code
//liveView.backgroundColor = PlaygroundColor.nef
PlaygroundLog.print("""
Welcome to nef Playground!
I'm ShawnBaek, who made Table Library.
Contact: shawn@shawnbaek.com
""")
