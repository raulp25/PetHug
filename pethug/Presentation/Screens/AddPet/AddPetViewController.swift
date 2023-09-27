//
//  AddPetViewController.swift
//  pethug
//
//  Created by Raul Pena on 26/09/23.
//

import UIKit
import Combine


final class AddPetViewController: UIViewController {
    
    //MARK: - Private components
    private lazy var contentStateVC = ContentStateViewController()
    private lazy var contentVc: AddPetContentViewController? = nil
    
    //MARK: - Private Properties
    private var subscriptions = Set<AnyCancellable>()
    private let viewModel: AddPetViewModel
    private let headerView = AddPetViewHeaderViewController()
    
    // MARK: - LifeCycle
    init(viewModel: AddPetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
//        render([""])
        bind()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//            try! AuthService().signOut()
//        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchPets(collection: .getPath(for: .dogs))
    }
    
    // MARK: - setup
    private func setup() {
//        view.backgroundColor = customRGBColor(red: 111, green: 235, blue: 210)
        view.backgroundColor = customRGBColor(red: 246, green: 246, blue: 246)
        view.isMultipleTouchEnabled = false
        view.isExclusiveTouch = true
        
        add(headerView)
        headerView.delegate = self
        headerView.view.setHeight(70)
        headerView.view.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop:
                UIScreen.main.bounds.size.height <= 700 ?
                40 :
                    UIScreen.main.bounds.size.height <= 926 ?
                    60 :
                        75
        )
        
        add(contentStateVC)
        contentStateVC.view.anchor(top: headerView.view.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    //MARK: - Bind
    private func bind() {
        viewModel
            .state
            .handleThreadsOperator()
            .sink { [weak self] state in
                switch state {
                case let .loaded(data):
                    self?.render(data)
                case .loading:
                    break
                case let .error(error):
                    print(": => \(error.localizedDescription)")
                    break
                }
            }.store(in: &subscriptions)
    }
    
    //MARK: - Private methods
    private func render(_ data: [Pet]) {
//        let snapData: [PetsContentViewController.SnapData] = [
//            .init(key: .pets, values: data.map { .pet($0) })
//        ]
        let snapData: [AddPetContentViewController.SnapData] = [
//            .init(key: .pets, values: data.map { .pet($0) })
        ]
        
        if contentStateVC.shownViewController == contentVc {
            contentVc?.snapData = snapData
        } else {
            contentVc = AddPetContentViewController(snapData: snapData)
            contentStateVC.transition(to: .render(contentVc!))
        }
        
    }
    
}

extension AddPetViewController: AddPetViewHeaderDelegate {
    func action() {
        viewModel.navigation?.startAddPetFlow()
    }
}
