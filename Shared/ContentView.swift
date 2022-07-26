//
//  ContentView.swift
//  Shared
//
//  Created by Ming-Ta Yang on 2022/7/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private(set) var bluetoothManager: BluetoothManager
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
        .onChange(of: bluetoothManager.alertMessage, perform: { newValue in
            if newValue != nil {
                alert = newValue
                bluetoothManager.alertMessage = nil
            }
        })
        .onAppear {
            if firstAppear {
                firstAppear = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    refresh()
                }
            }
        }
        .navigationViewStyle(.stack) 
    }
    
    private func refresh() {
        do {
            try bluetoothManager.startScanning()
        } catch {
            alert = error.localizedDescription
        }
    }
}
