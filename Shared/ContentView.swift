//
//  ContentView.swift
//  Shared
//
//  Created by Ming-Ta Yang on 2022/7/20.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var bluetoothManager = BluetoothManager()
    @State private var alert: String?
    
    var body: some View {
        NavigationView {
            PeripheralList(manager: bluetoothManager)
                .navigationTitle("Peripherals")
                .toolbar {
                    Button {
                        do {
                            try bluetoothManager.startScanning()
                        } catch {
                            alert = error.localizedDescription
                        }
                    } label: {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                }
        }
        .alert(alert ?? "Error", isPresented: Binding(get: { alert != nil }, set: { if !$0 { alert = nil} })) {
            Button("OK") {}
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
