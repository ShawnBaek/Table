//#-hidden-code
import UIKit
import PlaygroundSupport

let liveView = UIView()

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

PlaygroundLog.clear()
//#-end-hidden-code
liveView.backgroundColor = PlaygroundColor.nef
PlaygroundLog.print("Welcome to nef Playground!")