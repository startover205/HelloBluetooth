//
//  BluetoothManager.swift
//  HelloBluetooth (iOS)
//
//  Created by Ming-Ta Yang on 2022/7/20.
//

import CoreBluetooth

struct Peripheral: Identifiable {
    let id: String
    let rssi: Int
    let cbPeripheral: CBPeripheral
}

final class BluetoothManager: NSObject, ObservableObject {
    enum Error: Swift.Error, LocalizedError {
        case bluetoothNotReady(state: CBManagerState)
        
        var errorDescription: String? {
            switch self {
            case let .bluetoothNotReady(state: state):
                switch state {
                case .resetting:
                    return "Bluetooth is resetting."
                case .unsupported:
                    return "Bluetooth not supported for this device."
                case .unauthorized:
                    return "Bluetooth not authorized."
                case .poweredOff:
                    return "Please turn on bluetooth."
                case .poweredOn:
                    return nil
                case .unknown:
                    return "Unknown state"
                @unknown default:
                    return "Unknown state"
                }
            }
        }
    }
    
    private let queue = DispatchQueue(label: "BluetoothManager")
    
    private lazy var manager = CBCentralManager(delegate: self, queue: queue)
    
    private let preferredServices: [CBUUID]?
    
    private var discoveredPeripherals = [String: (peripheral: CBPeripheral, rssi: Int)]() {
        didSet {
            DispatchQueue.main.async {
                self.peripherals = self.discoveredPeripherals.map {
                    Peripheral(id: $0.key, rssi: $0.value.rssi, cbPeripheral: $0.value.peripheral)
                }
                .sorted { $0.rssi > $1.rssi }
            }
        }
    }
    @Published private(set) var peripherals = [Peripheral]()
    
    init(preferredServices: [CBUUID]? = nil) {
        self.preferredServices = preferredServices
        
        super.init()
    }
    
    func startScanning() throws {
        guard manager.state == .poweredOn else { throw Error.bluetoothNotReady(state: manager.state) }
        
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
