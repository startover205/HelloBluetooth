//
//  CharacteristicDetail.swift
//  HelloBluetooth (iOS)
//
//  Created by Ming-Ta Yang on 2022/7/20.
//

import SwiftUI
import CoreBluetooth
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

struct CharacteristicDetail: View {
    let characteristic: CBCharacteristic
    @StateObject var messenger = Messenger()
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("UUID")
                    
                    Spacer()
                    
                    Text(characteristic.uuid.uuidString)
                }
                
                HStack {
                    Text("Notifying")
                    
                    Spacer()
                    
                    Text(characteristic.isNotifying ? "YES" : "NO")
                }
                
            }
            
            Section {
                HStack {
                    Text("Read")
                    
                    Spacer()
                    
                    Text(characteristic.properties.contains(.read) ? "YES" : "NO")
                }
                
                HStack {
                    Text("Write")
                    
                    Spacer()
                    
                    Text(characteristic.properties.contains(.write) ? "YES" : "NO")
                }
                
                HStack {
                    Text("Write without Response")
                    
                    Spacer()
                    
                    Text(characteristic.properties.contains(.writeWithoutResponse) ? "YES" : "NO")
                }
            }
            
            if characteristic.properties.contains(.read) {
                Button {
                    characteristic.service?.peripheral?.readValue(for: characteristic)
                } label: {
                    Text("Read Value")
                }
            }
            
            Section("Values") {
                if messenger.values.isEmpty {
                    Text("No Values")
                        .foregroundColor(.gray)
                }
                
                ForEach(messenger.values) { message in
                    HStack {
                        Text(message.value)
                        Spacer()
                        Text(message.timestamp, formatter: messenger.dateFormatter)
                            .foregroundColor(.gray)
                    }
                }
            }
         
        }
        .navigationTitle(characteristic.uuid.description)
        .onAppear {
            messenger.cancellable = characteristic.publisher(for: \.value)
                .receive(on: RunLoop.main)
                .compactMap { $0 }
                .sink { [weak messenger] value in
                    messenger?.values.append(Message(value: value.message))
                }
        }
    }
}
