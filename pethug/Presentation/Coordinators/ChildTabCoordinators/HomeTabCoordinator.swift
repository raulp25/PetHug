//
//  HomeTabCoordinator.swift
//  pethug
//
//  Created by Raul Pena on 16/09/23.
//

import UIKit

final class HomeTabCoordinator: ChildTabCoordinator {
    var childCoordinators: [NavCoordinator] = .init()
    
    var parentCoordinator: InAppCoordinator?
    
    var rootViewController: UINavigationController = .init()
    
    let viewModel: PetsViewModel = .init(fetchPetsUC: FetchPets.composeFetchPetsUC(),
                                         filterPetsUC: FilterPets.composeFilterPetsUC(),
                                         likedPetUC: LikePet.composeLikePetUC(),
                                         dislikePetUC: DisLikePet.composeDisLikePetUC()
                                    )
    
    func start() {
        let vc = AnimalsStackContentViewController()
        vc.delegate = self
        rootViewController.pushViewController(vc, animated: true)
    }
    
    func startDogs() {
        viewModel.navigation = self
        viewModel.collection = .getPath(for: .dogs)
        let vc = PetsViewController(viewModel: viewModel)
        vc.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(vc, animated: true)
    }
    
    func startCats() {
        viewModel.navigation = self
        viewModel.collection = .getPath(for: .cats)
        let vc = PetsViewController(viewModel: viewModel)
        vc.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(vc, animated: true)
    }
    
    func startBirds() {
        viewModel.navigation = self
        viewModel.collection = .getPath(for: .birds)
        let vc = PetsViewController(viewModel: viewModel)
        vc.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(vc, animated: true)
    }
    
    func startRabbits() {
        viewModel.navigation = self
        viewModel.collection = .getPath(for: .rabbits)
        let vc = PetsViewController(viewModel: viewModel)
        vc.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(vc, animated: true)
    }
}

extension HomeTabCoordinator: AnimalsStackNavigatable {
    func didTapDogsBanner() {
        startDogs()
    }
    
    func didTapCatsBanner() {
        startCats()
    }
    
    func didTapBirdsBanner() {
        startBirds()
    }
    
    func didTapRabbitsBanner() {
        startRabbits()
    }
}

extension HomeTabCoordinator: PetsNavigatable {
    func tappedFilter() {
        let vc = FilterPetsContentViewController()
        vc.coordinator = self
        rootViewController.pushViewController(vc, animated: true)
    }
    

    func tapped(pet: Pet) {
        let vc = PetContentViewController(snapData: [
            .init(
                key: .gallery,
                values: [.images(pet.imagesUrls.map({ $0 }))]),
            .init(
                key: .nameLocation,
                values: [.nameLocation(.init(name: pet.name, breed: pet.breed, address: pet.address.rawValue))]),
            .init(
                key: .info,
                values: [.info(.init(age: pet.age, gender: pet.gender, size: pet.size, activityLevel: pet.activityLevel, socialLevel: pet.socialLevel, affectionLevel: pet.affectionLevel))]),
            .init(
                key: .description,
                values: [.description(pet.info)]),
            .init(
                key: .medical,
                values: [.medical(.init(internalDeworming: true, externalDeworming: false, microchip: true, sterilized: false, vaccinated: true))]),
            .init(
                key: .social,
                values: [.social(.init(maleDogFriendly: true, femaleDogFriendly: true, maleCatFriendly: false, femaleCatFriendly: false))])
        ])
        vc.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(vc, animated: true)
    }
}

