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
        tapGesture.delegate = context.coordinator
        
        DispatchQueue.main.async {
            if let window = controller.view.window {
                if window.gestureRecognizers?.contains(where: { $0 === tapGesture }) == false {
                    window.addGestureRecognizer(tapGesture)
                }
            }
        }
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: Context) {
        uiViewController.rootView = content
        
        DispatchQueue.main.async {
            if let window = uiViewController.view.window {
                let hasGesture = window.gestureRecognizers?.contains {
                    $0 is UITapGestureRecognizer && ($0.delegate === context.coordinator)
                } ?? false
                
                if !hasGesture {
                    let tapGesture = UITapGestureRecognizer(
                        target: context.coordinator,
                        action: #selector(Coordinator.dismissKeyboard)
                    )
                    tapGesture.cancelsTouchesInView = false
                    tapGesture.delegate = context.coordinator
                    window.addGestureRecognizer(tapGesture)
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        @objc func dismissKeyboard() {
            UIApplication.shared.endEditing()
        }

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
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
