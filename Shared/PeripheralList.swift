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
                NavigationLink {
                    PeripheralDetail(peripheral: peripheral)
                        .onAppear {
                            manager.manager.stopScan()
                            manager.manager.connect(peripheral.cbPeripheral)
                        }
                } label: {
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
        }
    }
}

struct PeripheralList_Previews: PreviewProvider {
    static var previews: some View {
        PeripheralList(manager: BluetoothManager())
    }
}
