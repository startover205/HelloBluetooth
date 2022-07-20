//
//  CharacteristicList.swift
//  HelloBluetooth (iOS)
//
//  Created by Ming-Ta Yang on 2022/7/20.
//

import SwiftUI
import CoreBluetooth

struct CharacteristicList: View {
    let service: CBService
    private var characteristics: [CBCharacteristic] { service.characteristics ?? [] }
    
    var body: some View {
        Form {
            if characteristics.isEmpty {
                Text("No characteristics found.")
            } else {
                ForEach(characteristics, id: \.uuid) { characteristic in
                    NavigationLink {
                        CharacteristicDetail(characteristic: characteristic)
                    } label: {
                        Text(characteristic.uuid.uuidString)
                    }
                }
            }
        }
        .navigationTitle("Characteristics")
    }
}
