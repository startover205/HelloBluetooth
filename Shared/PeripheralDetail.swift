//
//  PeripheralDetail.swift
//  HelloBluetooth (iOS)
//
//  Created by Ming-Ta Yang on 2022/7/20.
//

import SwiftUI
import CoreBluetooth

struct PeripheralDetail: View {
    let peripheral: CBPeripheral
    let rssi: Int
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("UUID")
                    
                    Spacer()
                    
                    Text(peripheral.identifier.uuidString)
                }
                
                HStack {
                    Text("RSSI")
                    
                    Spacer()
                    
                    Text(rssi.description)
                }
                
                HStack {
                    Text("State")
                    
                    Spacer()
                    
                    Text(peripheral.stateDescription)
                }
            }
           
            Section {
                NavigationLink {
                    ServiceList(peripheral: peripheral)
                } label: {
                    HStack {
                        Text("Services")
                        
                        Spacer()
                        
                        Text(peripheral.services?.count.description ?? "0")
                    }
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

