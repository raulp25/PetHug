//
//  UILabel+Extensions.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import UIKit

extension UILabel {
    func attributedRegularBoldColoredText(regularText: String, boldText:String, colorRegularText: UIColor? = nil, colorBoldText: UIColor? = nil, fontSize: CGFloat? = nil) {
        let atts: [NSAttributedString.Key: Any] = [
            .foregroundColor: colorRegularText ?? UIColor(white: 1, alpha: 0.87),
            .font: UIFont.systemFont(ofSize: fontSize ?? 16)
        ]
        
        let attributedTitle = NSMutableAttributedString(
            string: "\(regularText) ",
            attributes: atts
        )
        
        let boldAtts: [NSAttributedString.Key: Any] = [
            .foregroundColor: colorBoldText ?? UIColor.systemPink.withAlphaComponent(0.7),
            .font: UIFont.boldSystemFont(ofSize: fontSize ?? 16)
        ]
        
        attributedTitle.append(NSAttributedString(string: boldText, attributes: boldAtts))
        
        self.attributedText = attributedTitle
    }
    
    func attributedLightBoldColoredText(lightText: String, boldText:String, colorRegularText: UIColor? = nil, colorBoldText: UIColor? = nil, fontSize: CGFloat? = nil) {
        let atts: [NSAttributedString.Key: Any] = [
            .foregroundColor: colorRegularText ?? UIColor(white: 1, alpha: 0.87),
            .font: UIFont.systemFont(ofSize: fontSize ?? 16, weight: .light)
        ]
        
        let attributedTitle = NSMutableAttributedString(
            string: "\(lightText)",
            attributes: atts
        )
        
        let boldAtts: [NSAttributedString.Key: Any] = [
            .foregroundColor: colorBoldText ?? UIColor.systemPink.withAlphaComponent(0.7),
            .font: UIFont.boldSystemFont(ofSize: fontSize ?? 16)
        ]
        
        attributedTitle.append(NSAttributedString(string: boldText, attributes: boldAtts))
        
        self.attributedText = attributedTitle
    }
}
