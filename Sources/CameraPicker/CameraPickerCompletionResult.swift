//
//  CameraPickerCompletionResult.swift
//  CameraPicker
//
//  Created by Quentin Fasquel on 12/02/2025.
//

public enum CameraPickerCompletionResult: Sendable {
    case cancelled
    case failure(Error)
    case success(CameraPickerResult)

    internal init(_ imagePickerResult: ImagePickerResult) {
        switch imagePickerResult {
        case .cancelled:
            self = .cancelled
        case let .failure(error):
            self = .failure(error)
        case let .success(image):
            self = .success(CameraPickerResult(originalImage: image))
        }
    }
}
