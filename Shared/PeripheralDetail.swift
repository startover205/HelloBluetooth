//
//  PeripheralDetail.swift
//  HelloBluetooth (iOS)
//
//  Created by Ming-Ta Yang on 2022/7/20.
//

import SwiftUI
import CoreBluetooth

struct PeripheralDetail: View {
    let peripheral: Peripheral
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("UUID")
                    
                    Spacer()
                    
                    Text(peripheral.id)
                }
                
                HStack {
                    Text("RSSI")
                    
                    Spacer()
                    
                    Text(peripheral.rssi.description)
                }
                
                HStack {
                    Text("State")
                    
                    Spacer()
                    
                    Text(peripheral.cbPeripheral.stateDescription)
                }
            }
           
            Section {
                HStack {
                    Text("Services")
                    
                    Spacer()
                    
                    Text(peripheral.cbPeripheral.services?.count.description ?? 0.description)
                }
            }
        }
        .navigationTitle("Peripheral")
//        .onAppear {
//            manager.manager.connect(peripheral.cbPeripheral)
//        }
        
//        Text("Connecting...")
    }
}

