//
//  ImagePickerRepresentable.swift
//  CameraPicker
//
//  Created by Quentin Fasquel on 21/10/2024.
//

import SwiftUI
import AVFoundation

enum ImagePickerResult {
    case cancelled
    case failure(Error)
    case success(UIImage)
}

// MARK: - Image Picker

struct ImagePickerRepresentable<Overlay: View>: UIViewControllerRepresentable {

    /// Using a `SourceType` different than `.camera` is deprecated
    var sourceType: UIImagePickerController.SourceType
    var completion: ((ImagePickerResult) -> Void)?
    var safeAreaInsets: EdgeInsets
    var cameraOverlay: (CameraPicker) -> Overlay

    init(
        safeAreaInsets: EdgeInsets = .init(),
        @ViewBuilder cameraOverlay: @escaping (CameraPicker) -> Overlay
    ) {
        self.sourceType = .camera
        self.safeAreaInsets = safeAreaInsets
        self.cameraOverlay = cameraOverlay
    }

    init(
        sourceType: UIImagePickerController.SourceType,
        completion: @escaping (ImagePickerResult) -> Void
    ) where Overlay == EmptyView {
        self.sourceType = sourceType
        self.completion = completion
        self.safeAreaInsets = .init()
        self.cameraOverlay = { _ in EmptyView() }
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let pickerController = context.coordinator.pickerController
        pickerController.sourceType = sourceType
        pickerController.delegate = context.coordinator
        pickerController.allowsEditing = false
        if Overlay.self == EmptyView.self {
            return pickerController
        }

        // Disable camera control
        pickerController.showsCameraControls = false

        // Center camera view finder
        let aspectRatio = CGSize(width: 3, height: 4)
        let rect = AVMakeRect(aspectRatio: aspectRatio, insideRect: pickerController.view.bounds)
        pickerController.cameraViewTransform = .init(translationX: rect.origin.x,y: rect.origin.y)

        // Adding overlay container
        let overlayContainerView = UIView()
        overlayContainerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlayContainerView.frame = pickerController.view.bounds
        pickerController.cameraOverlayView = overlayContainerView

        // Instanciating SwiftUI overlay
        let overlayView = cameraOverlay(context.coordinator.cameraPicker)
        let overlayHostingController = UIHostingController(rootView: overlayView)
        overlayHostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlayHostingController.view.frame = overlayContainerView.bounds
        overlayHostingController.view.backgroundColor = .clear
        overlayHostingController.additionalSafeAreaInsets = safeAreaInsets.uiEdgeInsets
        overlayContainerView.addSubview(overlayHostingController.view)

        context.coordinator.overlayController = overlayHostingController
        return pickerController
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
//        context.coordinator.overlayController.rootView = cameraOverlay(context.coordinator.cameraPicker)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var continuation: CheckedContinuation<CameraPickerResult, Never>?
        var parent: ImagePickerRepresentable
        let pickerController = UIImagePickerController()
        var overlayController: UIHostingController<Overlay>!

        var cameraPicker: CameraPicker {
#if targetEnvironment(simulator)
            CameraPickerMock { [unowned pickerController] in
                pickerController.dismiss(animated: true)
            }
#else
            self
#endif
        }

        init(parent: ImagePickerRepresentable) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            guard continuation == nil else {
                continuation?.resume(returning: .init(info))
                continuation = nil

                return
            }

            guard let image = info[.originalImage] as? UIImage else {
                let error = NSError(domain: "", code: 0)
                return complete(picker: picker, result: .failure(error))
            }

            complete(picker: picker, result: .success(image))
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            complete(picker: picker, result: .cancelled)
        }

        fileprivate func complete(picker: UIImagePickerController, result: ImagePickerResult) {
            picker.dismiss(animated: true)
            parent.completion?(result)
        }
    }
}

extension ImagePickerRepresentable.Coordinator: @preconcurrency CameraPicker {

    func dismiss() {
        complete(picker: pickerController, result: .cancelled)
    }

    func takePicture() async -> CameraPickerResult {
        pickerController.cameraFlashMode = .off
        return await withCheckedContinuation { continuation in
            self.continuation = continuation
            pickerController.takePicture()
        }
    }
}

