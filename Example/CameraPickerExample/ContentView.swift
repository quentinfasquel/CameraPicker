//
//  ContentView.swift
//  CameraPickerExample
//
//  Created by Quentin Fasquel on 12/02/2025.
//

import CameraPicker
import SwiftUI

struct ContentView: View {
    @Namespace var namespace
    @State private var useCustomCameraPicker: Bool = false
    @State private var showsCameraPicker: Bool = false
    @State private var showsCustomCameraPicker: Bool = false
    @State private var selectedPhoto: UIImage?

    var body: some View {
        VStack {
            Toggle(
                "Use custom picker",
                systemImage: useCustomCameraPicker ? "checkmark.square.fill" : "square",
                isOn: $useCustomCameraPicker
            )
            .buttonBorderShape(.capsule)
            .buttonStyle(.plain)
            .controlSize(.large)
            .toggleStyle(.button)

            Button("Take a photo", systemImage: "camera") {
                if useCustomCameraPicker {
                    showsCustomCameraPicker = true
                } else {
                    showsCameraPicker = true
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .font(.title2.weight(.bold))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottom) {
            PhotoButton(photo: $selectedPhoto) {
                showsCustomCameraPicker = true
            }
            .disabled(!useCustomCameraPicker)
            .matchedTransitionSource(id: "camera", in: namespace)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .cameraPicker(isPresented: $showsCameraPicker, completion: { result in
            // Camera picker did finish
            if case let .success(result) = result {
                selectedPhoto = result.originalImage
            }
        })
        .cameraPicker(
            isPresented: $showsCustomCameraPicker,
            navigationTransition: .zoom(sourceID: "camera", in: namespace)
        ) { picker in
            CameraPickerOverlay(cameraPicker: picker) {
                selectedPhoto = $0
            }
        }
    }
}

#Preview {
    ContentView()
}
