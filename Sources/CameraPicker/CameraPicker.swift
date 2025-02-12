// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public protocol CameraPicker {
    func takePicture() async -> CameraPickerResult
    func dismiss()
}

