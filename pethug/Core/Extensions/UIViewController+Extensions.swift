//
//  UIViewController+Extensions.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import UIKit
import Combine

// MARK: - Alert
extension UIViewController {
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - hide keyboard on tap
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard(tap _: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}


// MARK: - Keyboard Publisher
extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

enum KeyboardState {
    case willShow
    case willHide
}

struct KeyboardObject: Equatable {
    var state: KeyboardState
    var height: CGFloat
}


extension UIViewController {
    private var keyboardWillShowPublisher: AnyPublisher<KeyboardObject, Never> {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification, object: nil)
            .compactMap {
                return KeyboardObject(state: .willShow, height: $0.keyboardHeight)
            }.eraseToAnyPublisher()
    }
    
    private var keyboardWillHidePublisher: AnyPublisher<KeyboardObject, Never> {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification, object: nil)
            .compactMap { _ in
                return KeyboardObject(state: .willHide, height: 0.0)
            }.eraseToAnyPublisher()
    }
    
    func keyboardListener() -> AnyPublisher<KeyboardObject, Never> {
        Publishers.Merge(keyboardWillShowPublisher, keyboardWillHidePublisher)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}

