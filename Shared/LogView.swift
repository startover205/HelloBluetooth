//
//  LogView.swift
//  HelloBluetooth (iOS)
//
//  Created by Ming-Ta Yang on 2022/7/20.
//

import SwiftUI

struct LogView: View {
    let log: String
    
    var body: some View {
        NavigationView {
            Form {
                Text(log)
                    .font(.caption2)
                    .padding()
            }
            .navigationTitle("Log")
        }
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView(log: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin malesuada orci neque, nec pretium orci feugiat eu. Donec semper, mi sed lobortis eleifend, velit quam tempus elit, quis vulputate sem lacus quis metus. Nunc sit amet tempus arcu, vitae posuere sapien. Cras nec est tincidunt diam ullamcorper ornare. Vivamus molestie id nisi vel dictum. Proin rhoncus tempus faucibus. Vestibulum placerat maximus nibh sit amet sodales. Sed cursus ante nisi, sit amet facilisis ex venenatis vel. Vestibulum vestibulum est felis, vitae malesuada quam suscipit eu. Etiam luctus nec sem sit amet lacinia. Vivamus posuere egestas sapien non maximus. Fusce elit tortor, consectetur vitae quam ut, iaculis rutrum orci. Suspendisse suscipit sodales orci sollicitudin egestas.")
    }
}
