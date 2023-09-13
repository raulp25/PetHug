//
//  Constants.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import UIKit

public func getWindowHeight() -> CGFloat {
    guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
        return 320
    }
    let windowHeight = window.frame.height
    return windowHeight
}

public func getWindowWidth() -> CGFloat {
    guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
        return 320
    }
    let windowWidth = window.frame.width
    return windowWidth
}

