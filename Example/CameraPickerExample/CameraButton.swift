//
//  CameraButtonStyle.swift
//  CameraPickerExample
//
//  Created by Quentin Fasquel on 12/02/2025.
//

import SwiftUI

struct CameraButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Circle()
            .stroke(.white, lineWidth: 3)
            .frame(width: 80, height: 80)
            .overlay {
                Circle()
                    .inset(by: configuration.isPressed ? 8 : 4)
                    .fill(.white)
                    .opacity(configuration.isPressed ? 0.6 : 1)
            }
    }
}

struct CameraButton: View {
    var action: (() -> Void)? = nil
    var body: some View {
        Button(action: action ?? {}) {
            EmptyView()
        }
        .buttonStyle(CameraButtonStyle())
    }
}

struct CameraButtonPlaceholder: View {
    var body: some View {
        CameraButton().hidden()
    }
}
