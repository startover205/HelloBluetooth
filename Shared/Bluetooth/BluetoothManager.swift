//
//  BluetoothManager.swift
//  HelloBluetooth (iOS)
//
//  Created by Ming-Ta Yang on 2022/7/20.
//

import CoreBluetooth


final class BluetoothManager: NSObject, ObservableObject {
    private let queue = DispatchQueue(label: "BluetoothManager")
    
    private lazy var manager = CBCentralManager(delegate: self, queue: queue)
    
    private let preferredServices: [CBUUID]?
    
    @Published private(set) var discoveredPeripherals = [String: (CBPeripheral, Int)]()
    
    init(preferredServices: [CBUUID]? = nil) {
        self.preferredServices = preferredServices
        
        super.init()
    }
    
    func startScanning() {
        guard manager.state == .poweredOn else { return }
        
        manager.scanForPeripherals(withServices: preferredServices)
    }

    
}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        guard central.state == .poweredOn else {
            print("Bluetooth is not available. Current state: \(central.state)")
            
            return
        }
        
        // to do ...
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let identifer = peripheral.identifier.uuidString
        
        discoveredPeripherals[identifer] = (peripheral, RSSI.intValue)
        
//        let existItem = discoveredPeripherals[identifer]
//
//        if existItem == nil {
//
//            // 可以通知使用者找到新裝置
//            print("Discovered: \([peripheral.name](http://peripheral.name/) ?? "NoName"), RSSI: \(RSSI), identifier: \(peripheral.identifier.uuidString), advertisementData: \(advertisementData)")
//
//        }
//
//        let now = Date()
//
//        let newItem = DiscoveredItem(peripheral: peripheral, rssi: RSSI.intValue, lastSeenDate: now) // RSSI是 NSNumber，可用 .intValue轉換成 Int
//
//        foundItems[identifer] = newItem
//
//        ... // 可以刷新裝清單tableView *可額外紀錄更新時間避免太頻繁更新
    }
    
}
