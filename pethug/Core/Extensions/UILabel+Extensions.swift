//
//  UILabel+Extensions.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import UIKit

extension UILabel {
    func attributedRegularBoldColoredText(regularText: String, boldText:String, color: UIColor? = nil) {
        let atts: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(white: 1, alpha: 0.87),
            .font: UIFont.systemFont(ofSize: 16)
        ]
        
        let attributedTitle = NSMutableAttributedString(
            string: "\(regularText) ",
            attributes: atts
        )
        
        let boldAtts: [NSAttributedString.Key: Any] = [
            .foregroundColor: color ?? UIColor.systemPink.withAlphaComponent(0.7),
            .font: UIFont.boldSystemFont(ofSize: 16)
        ]
        
        attributedTitle.append(NSAttributedString(string: boldText, attributes: boldAtts))
        
        self.attributedText = attributedTitle
    }
}
