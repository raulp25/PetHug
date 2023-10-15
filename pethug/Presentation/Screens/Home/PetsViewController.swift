//
//  PetsViewController.swift
//  pethug
//
//  Created by Raul Pena on 18/09/23.
//

import UIKit
import Combine

//protocol PetsViewControllerDelegate: AnyObject {
//    func didTap(recipient: Any)
////    func didTap(_: Any)
//}

final class PetsViewController: UIViewController {
    
    //MARK: - Private components
    private lazy var contentStateVC = ContentStateViewController()
    private lazy var contentVc: PetsContentViewController? = nil
    private let headerView = PetsViewHeaderViewController()
    
    //MARK: - Private Properties
    private var subscriptions = Set<AnyCancellable>()
    private let viewModel: PetsViewModel
    
    // MARK: - LifeCycle
    init(viewModel: PetsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // MARK: - setup
    private func setup() {
        view.backgroundColor = customRGBColor(red: 245, green: 245, blue: 245)
        view.isMultipleTouchEnabled = false
        view.isExclusiveTouch = true
        
        add(headerView)
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
        headerView.delegate = self
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
                    self?.renderLoading()
                case let .error(error):
                    self?.alert(message: "Hubo un error, intenta nuevamente")
                    print("error in Pets VC: => \(error.localizedDescription)")
                    break
                }
            }.store(in: &subscriptions)
    }
    
    //MARK: - Private methods
    private func render(_ data: [Pet]) {
        let snapData: [PetsContentViewController.SnapData] = [
            .init(key: .pets, values: data.map { .pet($0) })
        ]
        if contentStateVC.shownViewController == contentVc {
            contentVc?.snapData = snapData
        } else {
            contentVc = PetsContentViewController(snapData: snapData)
            contentVc?.delegate = self
            contentStateVC.transition(to: .render(contentVc!))
        }
    }
    
    private func renderLoading() {
        contentStateVC.transition(to: .loading)
    }
    
}

extension PetsViewController: PetsViewHeaderDelegate {
    func didTapFilter() {
        viewModel.navigation?.tappedFilter()
    }
}

extension PetsViewController: PetsContentViewControllerDelegate {
    func executeFetch() {
        if viewModel.isFilterMode() {
            viewModel.fetchPetsWithFilter()
        } else {
            viewModel.fetchPets(collection: "birds")
        }
    }
    
    func didTap(pet: Pet) {
        viewModel.navigation?.tapped(pet: pet)
    }
    
    func didLike(pet: Pet, completion: @escaping (Bool) -> Void) {
        viewModel.likedPet(pet: pet) { success in
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
        
    }
    
}
