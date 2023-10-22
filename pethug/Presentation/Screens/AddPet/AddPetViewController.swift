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
        bind()
        viewModel.fetchUserPets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewwill appear: =>")
        if viewModel.isNetworkOnline == false {
            viewModel.fetchUserPets(resetPagination: true)
        }
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // MARK: - setup
    private func setup() {
        view.backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
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
                case let .loaded(data, debounce):
                    self?.render(data, debounce)
                case .loading:
                    break
                case let .error(error):
                    self?.renderError(message: "Hubo un error, intenta nuevamente", title: "Error")
                case .networkError:
                    self?.renderError(message: "Sin conexion a internet, verifica tu conexion", title: "Sin conexión")
                }
            }.store(in: &subscriptions)
    }
    
    //MARK: - Private methods
    private func render(_ data: [Pet], _ debounce: Bool = false) {
        let snapData: [AddPetContentViewController.SnapData] = [
            .init(key: .pets, values: data.map { .pet($0) })
        ]
        
        if contentStateVC.shownViewController == contentVc {
            contentVc?.snapData = snapData
            contentVc?.debounce = debounce
        } else {
            contentVc = AddPetContentViewController(snapData: snapData)
            contentVc?.delegate = self
            contentStateVC.transition(to: .render(contentVc!))
        }
    }
    
    private func renderError(message: String, title: String = "") {
        DispatchQueue.main.async { [weak self] in
            self?.alert(message: message, title: title)
        }
    }

}

extension AddPetViewController: AddPetViewHeaderDelegate {
    func action() {
        viewModel.navigation?.startAddPetFlow()
    }
}
extension AddPetViewController: AddPetContentViewControllerDelegate {
    func executeFetch() {
        viewModel.fetchUserPets()
    }
    func didTapEdit(pet: Pet) {
        if !(NetworkMonitor.shared.isConnected) {
            renderError(message: "Sin conexion a internet, verifica tu conexion", title: "Sin conexión")
            return
        }
        viewModel.navigation?.startEditPetFlow(pet: pet)
    }
    func didTapDelete(collection path: String, id: String) async  -> Bool {
            let result = await viewModel.deletePet(collection: path, id: id)
            return result
    }
}
