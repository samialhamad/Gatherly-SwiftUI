//
//  View+KeyboardDismissable.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/3/25.
//

import SwiftUI

private struct KeyboardDismissableView<Content: View>: UIViewControllerRepresentable {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    func makeUIViewController(context: Context) -> UIHostingController<Content> {
        let controller = UIHostingController(rootView: content)
        let tapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false
        controller.view.addGestureRecognizer(tapGesture)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: Context) {
        uiViewController.rootView = content
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject {
        @objc func dismissKeyboard() {
            UIApplication.shared.endEditing()
        }
    }
}

extension View {
    func keyboardDismissable() -> some View {
        KeyboardDismissableView {
            self
        }
    }
}
