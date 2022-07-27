//
//  LogView.swift
//  HelloBluetooth (iOS)
//
//  Created by Ming-Ta Yang on 2022/7/20.
//

import SwiftUI

let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMdd_hhmm"
    return dateFormatter
}()

struct LogView: View {
    @Binding private(set) var log: String
    
    var body: some View {
        NavigationView {
            Form {
                Text(log)
                    .font(.caption2)
                    .padding()
            }
            .navigationTitle("Log")
            .toolbar {
                HStack {
                    Button {
                        log.removeAll()
                    } label: {
                        Label("Delete Log", systemImage: "trash")
                    }
                    
                    
                    Button {
                        
                        let tempURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(dateFormatter.string(from: Date())).txt")
                        
                        try! log.write(to: tempURL, atomically: true, encoding: .utf8)
                        
                        let controller = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
                        
                        let keyWindow = UIApplication.shared.connectedScenes
                            .filter { $0.activationState == .foregroundActive }
                            .first(where: { $0 is UIWindowScene })
                            .flatMap({ $0 as? UIWindowScene })?.windows
                            .first(where: \.isKeyWindow)
                        
                        if var topController = keyWindow?.rootViewController {
                            while let presentedViewController = topController.presentedViewController {
                                topController = presentedViewController
                            }
                            
                            controller.popoverPresentationController?.sourceView = topController.view
                            //Setup share activity position on screen on bottom center
                            controller.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height, width: 0, height: 0)
                            controller.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
                            
                            topController.present(controller, animated: true)
                        }
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
            }
        }
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView(log: .constant("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin malesuada orci neque, nec pretium orci feugiat eu. Donec semper, mi sed lobortis eleifend, velit quam tempus elit, quis vulputate sem lacus quis metus. Nunc sit amet tempus arcu, vitae posuere sapien. Cras nec est tincidunt diam ullamcorper ornare. Vivamus molestie id nisi vel dictum. Proin rhoncus tempus faucibus. Vestibulum placerat maximus nibh sit amet sodales. Sed cursus ante nisi, sit amet facilisis ex venenatis vel. Vestibulum vestibulum est felis, vitae malesuada quam suscipit eu. Etiam luctus nec sem sit amet lacinia. Vivamus posuere egestas sapien non maximus. Fusce elit tortor, consectetur vitae quam ut, iaculis rutrum orci. Suspendisse suscipit sodales orci sollicitudin egestas."))
    }
}
