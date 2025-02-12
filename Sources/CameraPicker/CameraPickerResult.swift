//
//  CameraPickerResult.swift
//  CameraPicker
//
//  Created by Quentin Fasquel on 12/02/2025.
//

import UIKit

public struct CameraPickerResult: Sendable {
    public var originalImage: UIImage?

    init(originalImage: UIImage? = nil) {
        self.originalImage = originalImage
    }

    init(_ keyValues: [UIImagePickerController.InfoKey: Any]) {
        originalImage = keyValues[.originalImage] as? UIImage
    }
}
