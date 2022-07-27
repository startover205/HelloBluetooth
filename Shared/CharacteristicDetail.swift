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
    private var peripheral: CBPeripheral? { characteristic.service?.peripheral }
    private var isConnected: Bool { peripheral?.state == .connected }

    @StateObject private var messenger = Messenger()
    @StateObject private var viewModel = CharacteristicDetailViewModel()
    @State private var isNotifying: Bool
    @State private var isFirstAppear = true
    @State private var alertMessage: String?
    @State private var writeWithResponseValue = ""
    @State private var writeWithoutResponseValue = ""
    
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
                    guard isConnected else {
                        showDisconnectPrompt()
                        return
                    }
                    
                    peripheral?.readValue(for: characteristic)
                } label: {
                    Text("Read Value")
                }
            }
            
            if characteristic.properties.contains(.write) {
                VStack(alignment: .leading) {
                    Text("Write Value with Response")
                        .bold()
                    
                    HStack {
                        TextField("Enter Value", text: $writeWithResponseValue)
                        
                        Button {
                            guard isConnected else {
                                showDisconnectPrompt()
                                return
                            }
                            
                            guard let data = writeWithResponseValue.data(using: .utf8) else {
                                alertMessage = "Invalid Input"
                                return
                            }
                            
                            peripheral?.writeValue(data, for: characteristic, type: .withResponse)
                        } label: {
                            Text("Send")
                        }
                        .buttonStyle(.plain)
                        .disabled(writeWithResponseValue.isEmpty)
                    }
                }
            }
            
            if characteristic.properties.contains(.writeWithoutResponse) {
                VStack(alignment: .leading) {
                    Text("Write Value without Response")
                        .bold()
                    
                    HStack {
                        TextField("Enter Value", text: $writeWithoutResponseValue)
                        
                        Button {
                            guard isConnected else {
                                showDisconnectPrompt()
                                return
                            }
                            
                            guard let data = writeWithoutResponseValue.data(using: .utf8) else {
                                alertMessage = "Invalid Input"
                                return
                            }
                            
                            peripheral?.writeValue(data, for: characteristic, type: .withResponse)
                        } label: {
                            Text("Send")
                        }
                        .buttonStyle(.plain)
                        .disabled(writeWithoutResponseValue.isEmpty)
                    }
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
            guard isConnected else {
                showDisconnectPrompt()
                return
            }
            
            characteristic.service?.peripheral?.setNotifyValue(newValue, for: characteristic)
        }
        .alert(alertMessage ?? "", isPresented: Binding(get: { alertMessage != nil }, set: { if !$0 { alertMessage = nil } })) {
            Text("OK")
        }
    }
    
    private func showDisconnectPrompt() {
        alertMessage = "Device is disconnected"
    }
}
