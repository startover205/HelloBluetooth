//
//  ServiceList.swift
//  HelloBluetooth (iOS)
//
//  Created by Ming-Ta Yang on 2022/7/20.
//

import SwiftUI
import CoreBluetooth

struct ServiceList: View {
    @ObservedObject var peripheral: Peripheral
    private var services: [CBService] { peripheral.cbPeripheral.services ?? [] }
    
    var body: some View {
        Form {
            if services.isEmpty {
                Text("No services found.")
            } else {
                ForEach(services, id: \.uuid) { service in
                    NavigationLink {
                        CharacteristicList(service: service)
                    } label: {
                        VStack {
                            Text(service.uuid.uuidString)
                        }
                    }
                }
            }
        }
        .navigationTitle("Services")
    }
}

