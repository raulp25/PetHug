//
//  FavoriteTabCoordinator.swift
//  pethug
//
//  Created by Raul Pena on 15/10/23.
//

import UIKit

final class FavoriteTabCoordinator: ChildTabCoordinator {
    var childCoordinators: [NavCoordinator] = .init()
    
    var parentCoordinator: InAppCoordinator?
    
    var rootViewController: UINavigationController = .init()
    
    func start() {
        let viewModel: FavoritesViewModel = .init(fetchFavoritePetsUC: FetchFavoritePets.composeFetchFavoritePetsUC(),
                                                  dislikePetUC: DisLikePet.composeDisLikePetUC(),
                                                  authService: AuthService()
                                             )
        viewModel.navigation = self
        let vc = FavoritesViewController(viewModel: viewModel)
        rootViewController.pushViewController(vc, animated: true)
    }
}

extension FavoriteTabCoordinator: FavoritesNavigatable {
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

