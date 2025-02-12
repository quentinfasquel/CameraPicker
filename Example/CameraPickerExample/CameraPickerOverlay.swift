//
//  CameraPickerOverlay.swift
//  CameraPickerExample
//
//  Created by Quentin Fasquel on 12/02/2025.
//

import CameraPicker
import SwiftUI

struct CameraPickerOverlay: View {
    @State private var displayImage: Bool = false
    @State private var originalImage: UIImage?
    @State private var takePictureCount: Int = 0

    var cameraPicker: CameraPicker
    var usePhoto: (UIImage) -> Void

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue.gradient)
                .ignoresSafeArea()
                .opacity(originalImage == nil ? 0 : 1)

            Color.black
                .ignoresSafeArea()
                .opacity(originalImage == nil ? 0 : (displayImage ? 0 : 1))
//                .opacity(displayImage ? 0 : 1)
                .animation(.smooth, value: displayImage)

            if let originalImage {
                Image(uiImage: originalImage)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(3/4, contentMode: .fit)
                    .clipShape(.rect(cornerRadius: displayImage ? 24 : 0))
                    .padding(displayImage ? 16 : 0)
                    .animation(.spring, value: displayImage)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .onAppear {
                        displayImage = true
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .topLeading) {
            Button("", systemImage: "xmark") {
                cameraPicker.dismiss()
            }
            .foregroundStyle(.white)
            .contentShape(.rect)
            .padding()
        }

        .overlay(alignment: .bottom) {
            bottomToolbar
        }
        .task(id: takePictureCount) {
            guard takePictureCount > 0 else {
                return
            }
            let result = await cameraPicker.takePicture()
            await MainActor.run { originalImage = result.originalImage }
        }
    }

    @ViewBuilder private var bottomToolbar: some View {
        HStack {
            Spacer()
            if displayImage, let originalImage {
                Button("Retake") { didTapRetakePhoto() }
                Spacer()
                CameraButtonPlaceholder()
                Spacer()
                Button("Use photo") { didTapUsePhoto(originalImage) }
            } else {
                CameraButton { takePictureCount += 1 }
            }
            Spacer()
        }
        .transition(.identity)
        .buttonStyle(.plain)
        .foregroundStyle(.white)
    }

    private func didTapRetakePhoto() {
        withAnimation(.snappy) {
            displayImage = false
        } completion: {
            // Reset photo
            originalImage = nil
        }
    }

    private func didTapUsePhoto(_ image: UIImage) {
        cameraPicker.dismiss()
        usePhoto(image)
    }
}
