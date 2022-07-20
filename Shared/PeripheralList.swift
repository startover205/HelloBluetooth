//
//  PeripheralList.swift
//  HelloBluetooth (iOS)
//
//  Created by Ming-Ta Yang on 2022/7/20.
//

import SwiftUI
import CoreBluetooth

extension CBPeripheral {
    var stateDescription: String {
        switch state {
        case .disconnected:
            return "Disconnected"
        case .connecting:
            return "Connecting"
        case .connected:
            return "Connected"
        case .disconnecting:
            return "Disconnecting"
        @unknown default:
            return "Unknown"
        }
    }
}

struct PeripheralList: View {
    @ObservedObject var manager: BluetoothManager
    
    var body: some View {
        if manager.peripherals.isEmpty {
            Text("No peripheral found")
        } else {
            List(manager.peripherals) { peripheral in
                let cbPeripheral = peripheral.cbPeripheral
                
                NavigationLink {
                    PeripheralDetail(peripheral: peripheral.cbPeripheral, rssi: peripheral.rssi)
                        .onAppear {
                            manager.manager.stopScan()
                            manager.manager.connect(peripheral.cbPeripheral)
                        }
                } label: {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text("State: \(cbPeripheral.stateDescription)")
                            Text(cbPeripheral.name ?? "Unknown")
                                .font(.headline)
                            Text("Servcies: \(cbPeripheral.services?.count ?? 0)")
                        }
                        
                        Spacer()
                        
                        Text("RSSI: \(peripheral.rssi)")
                    }
                }
            }
        }
    }
}

struct PeripheralList_Previews: PreviewProvider {
    static var previews: some View {
        PeripheralList(manager: BluetoothManager())
    }
}
