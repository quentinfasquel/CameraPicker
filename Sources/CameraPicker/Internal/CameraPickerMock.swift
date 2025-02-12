//
//  Untitled.swift
//  CameraPicker
//
//  Created by Quentin Fasquel on 12/02/2025.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

public struct CameraPickerMock: CameraPicker {

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
    public func dismiss() {
        _dismiss()
    }

    public func takePicture() async -> CameraPickerResult {
        try? await Task.sleep(nanoseconds: Self.delay * NSEC_PER_MSEC)
        return .init(originalImage: Self.imageGenerator())
    }
}
