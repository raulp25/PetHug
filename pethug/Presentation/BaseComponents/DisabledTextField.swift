//
//  DisabledTextField.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import UIKit

class DisabledTextField: UITextField {
    override func caretRect(for _: UITextPosition) -> CGRect {
        return CGRect.zero
    }

    override func selectionRects(for _: UITextRange) -> [UITextSelectionRect] {
        return []
    }

    override func canPerformAction(_: Selector, withSender _: Any?) -> Bool {
        return false
    }
}

