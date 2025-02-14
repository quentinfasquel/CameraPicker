//
//  Untitled.swift
//  CameraPicker
//
//  Created by Quentin Fasquel on 12/02/2025.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

public final class CameraPickerMock: CameraPicker {

    /// Delay in milliseconds
    public nonisolated(unsafe) static var delay: UInt64 = 200

    ///
    public nonisolated(unsafe) static var imageGenerator: () -> UIImage? = {
        let imageRect = CGRect(x: 0, y: 0, width: 300, height: 400)
        guard let ciImage = CIFilter.randomGenerator().outputImage?.cropped(to: imageRect),
              let cgImage = CIContext().createCGImage(ciImage, from: imageRect) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }

    var _dismiss: () -> Void
    var _takePicture: () async -> CameraPickerResult

    public init(
        dismiss: @escaping () -> Void,
        takePicture: @escaping () async -> CameraPickerResult = {
            try? await Task.sleep(nanoseconds: CameraPickerMock.delay * NSEC_PER_MSEC)
            return .init(originalImage: CameraPickerMock.imageGenerator())
        }
    ) {
        _dismiss = dismiss
        _takePicture = takePicture
    }

    public func dismiss() {
        _dismiss()
    }

    public func takePicture() async -> CameraPickerResult {
        await _takePicture()
    }
}
