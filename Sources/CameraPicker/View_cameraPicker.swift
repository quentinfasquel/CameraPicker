//
//  View_cameraPicker.swift
//  CameraPicker
//
//  Created by Quentin Fasquel on 12/02/2025.
//

public import SwiftUI

extension View {

    public func cameraPicker(
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        completion: ((CameraPickerCompletionResult) -> Void)? = nil
    ) -> some View {
        fullScreenCover(isPresented: isPresented, onDismiss: onDismiss ?? {}) {
            ImagePickerRepresentable(
                sourceType: .camera,
                completion: { completion?(.init($0)) }
            )
            .ignoresSafeArea()
        }
    }

    public func cameraPicker<Overlay: View>(
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        cameraOverlay: @escaping (CameraPicker) -> Overlay
    ) -> some View {

        fullScreenCover(isPresented: isPresented, onDismiss: onDismiss ?? {}) {
            GeometryReader { geometry in
                ImagePickerRepresentable(
                    safeAreaInsets: geometry.safeAreaInsets,
                    cameraOverlay: cameraOverlay
                )
                .ignoresSafeArea()
            }
        }
    }
}


@available(iOS 18, *)
extension View {

    public func cameraPicker<T: NavigationTransition>(
        isPresented: Binding<Bool>,
        navigationTransition: T,
        onDismiss: (() -> Void)? = nil,
        completion: ((CameraPickerCompletionResult) -> Void)? = nil
    ) -> some View {
        fullScreenCover(isPresented: isPresented, onDismiss: onDismiss ?? {}) {
            ImagePickerRepresentable(
                sourceType: .camera,
                completion: { completion?(.init($0)) }
            )
            .ignoresSafeArea()
            .navigationTransition(navigationTransition)
        }
    }

    public func cameraPicker<Overlay: View, T: NavigationTransition>(
        isPresented: Binding<Bool>,
        navigationTransition: T,
        onDismiss: (() -> Void)? = nil,
        cameraOverlay: @escaping (CameraPicker) -> Overlay
    ) -> some View {
        fullScreenCover(isPresented: isPresented, onDismiss: onDismiss ?? {}) {
            GeometryReader { geometry in
                ImagePickerRepresentable(
                    safeAreaInsets: geometry.safeAreaInsets,
                    cameraOverlay: cameraOverlay
                )
                .ignoresSafeArea()
            }
            .navigationTransition(navigationTransition)
        }
    }
}
