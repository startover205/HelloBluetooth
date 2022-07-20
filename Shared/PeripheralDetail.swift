//
//  PeripheralDetail.swift
//  HelloBluetooth (iOS)
//
//  Created by Ming-Ta Yang on 2022/7/20.
//

import SwiftUI
import CoreBluetooth

struct PeripheralDetail: View {
    @ObservedObject var peripheral: Peripheral
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("UUID")
                    
                    Spacer()
                    
                    Text(peripheral.id.uuidString)
                }
                
                HStack {
                    Text("RSSI")
                    
                    Spacer()
                    
                    Text(peripheral.rssi.description)
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
                        
                        Text(peripheral.services.count.description)
                    }
                }
            }
        }
        .navigationTitle("Peripheral")
    }
}

