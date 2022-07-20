//
//  ServiceList.swift
//  HelloBluetooth (iOS)
//
//  Created by Ming-Ta Yang on 2022/7/20.
//

import SwiftUI
import CoreBluetooth

struct ServiceList: View {
    let peripheral: CBPeripheral
    private var services: [CBService] {
        peripheral.services ?? []
    }
    
    var body: some View {
        Form {
            if services.isEmpty {
                Text("No services found.")
            } else {
                ForEach(services, id: \.uuid) { service in
                    VStack {
                        Text(service.uuid.uuidString)
                    }
                }
            }
        }
    }
}

