//
//  PeripheralRow.swift
//  HelloBluetooth (iOS)
//
//  Created by Ming-Ta Yang on 2022/7/20.
//

import SwiftUI

struct PeripheralRow: View {
    @ObservedObject var peripheral: Peripheral
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("State: \(peripheral.stateDescription)")
                Text(peripheral.name ?? "Unknown")
                    .font(.headline)
                Text("Servcies: \(peripheral.services.count)")
            }
            
            Spacer()
            
            Text("RSSI: \(peripheral.rssi)")
        }
    }
}

