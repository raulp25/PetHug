//
//  FavoritesViewController.swift
//  pethug
//
//  Created by Raul Pena on 15/10/23.
//

import UIKit
import Combine

//protocol PetsViewControllerDelegate: AnyObject {
//    func didTap(recipient: Any)
////    func didTap(_: Any)
//}

final class FavoritesViewController: UIViewController {
    
    //MARK: - Private components
    private lazy var contentStateVC = ContentStateViewController()
    private lazy var contentVc: FavoritesContentViewController? = nil
    private let headerView = FavoritesViewHeaderViewController()
    
    //MARK: - Private Properties
    private var subscriptions = Set<AnyCancellable>()
    private let viewModel: FavoritesViewModel
    private var isMounted = false
    
    // MARK: - LifeCycle
    init(viewModel: FavoritesViewModel) {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavoritePets(resetData: true)
    }
    
    // MARK: - setup
    private func setup() {
        view.backgroundColor = customRGBColor(red: 245, green: 245, blue: 245)
        view.isMultipleTouchEnabled = false
        view.isExclusiveTouch = true
        
        add(headerView)
        add(contentStateVC)
        
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
        let snapData: [FavoritesContentViewController.SnapData] = [
            .init(key: .pets, values: data.map { .pet($0) })
        ]
        if contentStateVC.shownViewController == contentVc {
            contentVc?.snapData = snapData
        } else {
            contentVc = FavoritesContentViewController(snapData: snapData)
            contentVc?.delegate = self
            contentStateVC.transition(to: .render(contentVc!))
        }
    }
    
    private func renderEmptyView() {
        guard !(contentStateVC.shownViewController is EmptyDataViewController) else { return }
        let vc = EmptyDataViewController(title: "Favoritos",
                                         caption: "Aún no has seleccionado ningun favorito",
                                         namedImage:  "empty1")
        
        contentStateVC.transition(to: .render(vc))
    }
    
    private func renderError(message: String, title: String = "") {
        guard !(contentStateVC.shownViewController is ErrorViewController) else { return }
        contentStateVC.transition(to: .failed(PetsError.defaultCustom("sin conexion a internet")))
    }
    
    private func renderLoading() {
        contentStateVC.transition(to: .loading)
    }
    
}


extension FavoritesViewController: FavoritesContentViewControllerDelegate {
    func executeFetch() {
        viewModel.fetchFavoritePets()
    }
    
    func didTap(pet: Pet) {
        viewModel.navigation?.tapped(pet: pet)
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

