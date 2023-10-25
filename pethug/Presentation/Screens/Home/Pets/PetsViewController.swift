//
//  PetsViewController.swift
//  pethug
//
//  Created by Raul Pena on 18/09/23.
//

import UIKit
import Combine

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
        bind()
        setup()
        print("view didload fetchpets ejecuta 788: => ")
        viewModel.fetchPets(collection: viewModel.collection, resetFilterQueries: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // MARK: - setup
    private func setup() {
        view.backgroundColor = customRGBColor(red: 245, green: 245, blue: 245)
        view.isExclusiveTouch = true
        
        add(headerView)
        add(contentStateVC)
        
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
        headerView.view.setHeight(70)
        headerView.delegate = self
        
        contentStateVC.view.anchor(
            top: headerView.view.bottomAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )
    }
    
    //MARK: - Bind
    private func bind() {
        viewModel
            .state
            .handleThreadsOperator()
            .sink { [weak self] state in
                switch state {
                case .loading:
                    self?.renderLoading()
                case let .loaded(data):
                    self?.render(data)
                case .empty:
                    self?.renderEmptyView()
                case .error(_):
                    self?.renderError(message: "Hubo un error, intenta nuevamente")
                case .networkError:
                    self?.renderError(message: "Sin conexion a internet, verifica tu conexion", title: "Sin conexión")
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
    
    private func renderEmptyView() {
        let vc = EmptyDataViewController(namedImage: "empty1")
        contentStateVC.transition(to: .render(vc))
    }
    
    private func renderError(message: String, title: String = "") {
        contentStateVC.transition(to: .failed(PetsError.defaultCustom("sin conexion a internet")))
    }
    
    private func renderLoading() {
        contentStateVC.transition(to: .loading)
    }
    
}

extension PetsViewController: PetsViewHeaderDelegate {
    func didTapIcon() {
        navigationController?.popViewController(animated: true)
    }
    func didTapFilter() {
        viewModel.navigation?.tappedFilter()
    }
}

extension PetsViewController: PetsContentViewControllerDelegate {
    func executeFetch() {
        if viewModel.isFilterMode() {
            //No arguments passed cause at this point the options has been set by the filter pets vc
            viewModel.fetchPetsWithFilter()
        } else {
            viewModel.fetchPets(collection: viewModel.collection, resetFilterQueries: false)
        }
    }
    
    func didTap(pet: Pet) {
        viewModel.navigation?.tapped(pet: pet)
    }
    
    func didLike(pet: Pet, completion: @escaping (Bool) -> Void) {
        viewModel.likedPet(pet: pet) { result in
            if result == true {
                completion(true)
            } else {
                completion(false)
            }
        }
        
    }
    
    func didDislike(pet: Pet, completion: @escaping (Bool) -> Void) {
        viewModel.dislikedPet(pet: pet) { result in
            if result == true {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
}
