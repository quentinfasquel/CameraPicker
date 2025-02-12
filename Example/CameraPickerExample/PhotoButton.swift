//
//  PhotoButton.swift
//  CameraPickerExample
//
//  Created by Quentin Fasquel on 13/02/2025.
//

import SwiftUI

struct PhotoButton: View {
    @Environment(\.isEnabled) private var isEnabled
    @Binding var photo: UIImage?
    var aspectRatio: CGFloat = 1
    var width: CGFloat = 120
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Color.black
                .aspectRatio(aspectRatio, contentMode: .fit)
                .frame(width: width)
                .overlay {
                    if let photo {
                        Image(uiImage: photo)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image(systemName: "camera.fill")
                            .foregroundStyle(.white)
                            .font(.largeTitle)
                    }
                }
                .opacity(isEnabled ? 1 : 0.45)
                .clipShape(.rect(cornerRadius: 24))
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }
}

