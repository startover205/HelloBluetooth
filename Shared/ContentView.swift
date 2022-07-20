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
    @State private var firstAppear = true
    
    var body: some View {
        NavigationView {
            PeripheralList(manager: bluetoothManager)
                .navigationTitle("Peripherals")
                .toolbar {
                    Button {
                        if bluetoothManager.isScanning {
                            bluetoothManager.stopScan()
                        } else {
                           refresh()
                        }
                       
                    } label: {
                        Label(bluetoothManager.isScanning ? "Stop" : "Refresh", systemImage: bluetoothManager.isScanning ? "xmark" : "arrow.clockwise")
                    }
                }
        }
        .alert(alert ?? "Error", isPresented: Binding(get: { alert != nil }, set: { if !$0 { alert = nil} })) {
            Button("OK") {}
        }
        .onAppear {
            if firstAppear {
                firstAppear = false
                
                refresh()
            }
        }
    }
    
    private func refresh() {
        do {
            try bluetoothManager.startScanning()
        } catch {
            alert = error.localizedDescription
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
