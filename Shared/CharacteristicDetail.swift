//
//  CharacteristicDetail.swift
//  HelloBluetooth (iOS)
//
//  Created by Ming-Ta Yang on 2022/7/20.
//

import SwiftUI
import CoreBluetooth

struct CharacteristicDetail: View {
    let characteristic: CBCharacteristic
    
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
        }
        .navigationTitle(characteristic.uuid.description)
    }
}
