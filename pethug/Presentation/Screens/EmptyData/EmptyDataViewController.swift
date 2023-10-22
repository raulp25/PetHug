//
//  EmptyViewController.swift
//  pethug
//
//  Created by Raul Pena on 22/10/23.
//

import UIKit

final class EmptyDataViewController: UIViewController {
    var titleTxt: String?
    var caption: String?
    var namedImage: String?
    var systemImage: String?
    
    init(
        title: String? = nil,
        caption: String? = nil,
        namedImage: String? = nil,
        systemImage: String? = nil
    ) {
        self.titleTxt  = title
        self.caption  = caption
        self.namedImage  = namedImage
        self.systemImage  = systemImage
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let childView = EmptyDataView(title: titleTxt,
                                      caption: caption,
                                      namedImage: namedImage,
                                      systemImage: systemImage)
        addChild(childView)
        childView.view.frame = view.bounds
        view.addSubview(childView.view)
        childView.didMove(toParent: self)
    }
}


