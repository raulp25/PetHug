//
//  IncreaseTapAreaButton.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import UIKit

final class IncreaseTapAreaButton: UIButton {
    // MARK: - Increase tappable area
    override func point(inside point: CGPoint, with _: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -15, dy: -15).contains(point)
    }
}

