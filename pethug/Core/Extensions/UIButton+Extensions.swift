//
//  UIButton+Extensions.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import UIKit

extension UIButton {
    func attributedRegularBoldColoredText(regularText: String, boldText:String, color: UIColor? = nil) {
        let atts: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black.withAlphaComponent(0.83),
            .font: UIFont.systemFont(ofSize: 14)
        ]
        
        let attributedTitle = NSMutableAttributedString(
            string: "\(regularText) ",
            attributes: atts
        )
        
        let boldAtts: [NSAttributedString.Key: Any] = [
            .foregroundColor: color ?? customRGBColor(red: 243, green: 117, blue: 121),
            .font: UIFont.boldSystemFont(ofSize: 14)
        ]
        
        attributedTitle.append(NSAttributedString(string: boldText, attributes: boldAtts))
        
        setAttributedTitle(attributedTitle, for: .normal)
    }
}
