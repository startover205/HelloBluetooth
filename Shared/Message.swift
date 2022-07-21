//
//  Message.swift
//  HelloBluetooth (iOS)
//
//  Created by Ming-Ta Yang on 2022/7/21.
//

import SwiftUI
import Combine

extension Data {
    var message: String {
        if count == 1 {
            return first!.description
        } else if let string = String(data: self, encoding: .utf8) {
            return string
        } else {
            return "HexString: \(self.hexString)\nHexDescription: \(self.hexDescription)"
        }
    }
}

struct Message: Identifiable {
    var id: Date { timestamp }
    
    let timestamp = Date()
    let value: String
}

final class Messenger: ObservableObject {
    @Published var values = [Message]()
    var cancellable: Cancellable?
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        return dateFormatter
    }()
}
