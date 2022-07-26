//
//  CharacteristicDetail.swift
//  HelloBluetooth (iOS)
//
//  Created by Ming-Ta Yang on 2022/7/20.
//

import SwiftUI
import CoreBluetooth
import Combine

final class CharacteristicDetailViewModel: ObservableObject {
    var cancellables = [Cancellable]()
}

struct CharacteristicDetail: View {
    let characteristic: CBCharacteristic
    @StateObject private var messenger = Messenger()
    @StateObject private var viewModel = CharacteristicDetailViewModel()
    @State private var isNotifying: Bool
    @State private var isFirstAppear = true
    
    init(characteristic: CBCharacteristic) {
        self.characteristic = characteristic
        self.isNotifying = characteristic.isNotifying
    }
    
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
                    
                    Text(isNotifying ? "YES" : "NO")
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
                
                HStack {
                    Text("Notify")
                    
                    Spacer()
                    
                    Text(characteristic.properties.contains(.notify) ? "YES" : "NO")
                }
            }
            
            if characteristic.properties.contains(.read) {
                Button {
                    characteristic.service?.peripheral?.readValue(for: characteristic)
                } label: {
                    Text("Read Value")
                }
            }
            
            if characteristic.properties.contains(.notify) {
                Toggle("Start Notifications", isOn: $isNotifying)
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
            if isFirstAppear {
                isFirstAppear = false
                
                messenger.cancellable = characteristic.publisher(for: \.value)
                    .receive(on: RunLoop.main)
                    .compactMap { $0 }
                    .sink { [weak messenger] value in
                        messenger?.values.append(Message(value: value.message))
                    }
            }
        }
        .onChange(of: isNotifying) { newValue in
            characteristic.service?.peripheral?.setNotifyValue(newValue, for: characteristic)
        }
    }
}
