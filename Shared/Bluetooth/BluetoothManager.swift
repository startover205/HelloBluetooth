//
//  BluetoothManager.swift
//  HelloBluetooth (iOS)
//
//  Created by Ming-Ta Yang on 2022/7/20.
//

import CoreBluetooth
import Combine

final class Peripheral: Identifiable, ObservableObject {
    @Published private(set) var services = [CBService]()
    @Published private(set) var stateDescription = "Unknown"
    @Published var rssi: Int
    
    var id: UUID { cbPeripheral.identifier }
    var name: String? { cbPeripheral.name }
    
    let cbPeripheral: CBPeripheral
    private var cancellable = [Cancellable]()
    
    init(rssi: Int, cbPeripheral: CBPeripheral) {
        self.rssi = rssi
        self.cbPeripheral = cbPeripheral
        
        cancellable.append(cbPeripheral.publisher(for: \.state)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { _ in
                self.stateDescription = cbPeripheral.stateDescription
            }))
        
        cancellable.append(cbPeripheral.publisher(for: \.services)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { _ in
                self.services = cbPeripheral.services ?? []
            }))
    }
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
    
    private(set) var manager: CBCentralManager!
    
    private let preferredServices: [CBUUID]?
    
    private var discoveredPeripherals = [String: Peripheral]() {
        didSet {
            DispatchQueue.main.async {
                self.peripherals = self.discoveredPeripherals.values.map { $0 }
                    .sorted { $0.rssi > $1.rssi }
            }
        }
    }
    @Published private(set) var peripherals = [Peripheral]()
    @Published private(set) var isScanning = false
    init(preferredServices: [CBUUID]? = nil) {
        self.preferredServices = preferredServices
        
        super.init()
        
        self.manager = CBCentralManager(delegate: self, queue: queue)
    }
    
    func startScanning() throws {
        guard manager.state == .poweredOn else { throw Error.bluetoothNotReady(state: manager.state) }
        
        manager.scanForPeripherals(withServices: preferredServices)
        
        isScanning = manager.isScanning
    }
    
    func stopScan() {
        manager.stopScan()
        
        isScanning = manager.isScanning
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
        print("\(Date())---\(#function)---")
        
        let identifer = peripheral.identifier.uuidString
        
        if let peripheral = discoveredPeripherals[identifer] {
            DispatchQueue.main.async {
                peripheral.rssi = RSSI.intValue
            }
        } else {
            discoveredPeripherals[identifer] = Peripheral(rssi: RSSI.intValue, cbPeripheral: peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("\(Date())---\(#function)---")
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Swift.Error?) {
        print("\(Date())---\(#function)--peripheral: \(peripheral.identifier)-error: \(String(describing: error))")
    }
}

extension BluetoothManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Swift.Error?) {
        print("\(Date())---\(#function)--peripheral: \(peripheral.identifier)-error: \(String(describing: error))")

        for service in peripheral.services ?? [] {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Swift.Error?) {
        print("\(Date())---\(#function)--\(service.uuid)-error: \(String(describing: error))")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Swift.Error?) {
        print("\(Date())---\(#function)---")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        print("\(Date())---\(#function)-invalidatedServices: \(invalidatedServices)--")
    }
}
