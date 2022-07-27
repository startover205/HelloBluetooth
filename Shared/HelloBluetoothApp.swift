//
//  HelloBluetoothApp.swift
//  Shared
//
//  Created by Ming-Ta Yang on 2022/7/20.
//

import SwiftUI

@main
struct HelloBluetoothApp: App {
    @State var log = ""
    @StateObject private var bluetoothManager = BluetoothManager()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView(bluetoothManager: bluetoothManager)
                    .tabItem {
                        Label("Scan", systemImage: "magnifyingglass")
                    }
                
                LogView(log: $log)
                    .tabItem {
                        Label("Log", systemImage: "text.bubble")
                    }
            }
            .onAppear {
                bluetoothManager.log = { text in
                    DispatchQueue.main.async {
                        log += text
                        log += "\n"
                    }
                }
            }
        }
    }
}
