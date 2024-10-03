//
//  MainCoordinator.swift
//  VenuesLocator
//
//  Created by Sasha Navruzova on 01.10.2024.
//

import UIKit

/// `MainCoordinator` is responsible for managing the app's navigation flow, including initializing the main view controllers.
/// This class ensures that all necessary dependencies are instantiated and injected properly, promoting separation of concerns.
class MainCoordinator {
    private let navigationController: UINavigationController
    private let venueAPI: VenueAPI
    private let localStorageService: LocalStorageService
    private weak var venuesViewModel: VenuesViewModel?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.venueAPI = VenueAPI()
        self.localStorageService = LocalStorageService()
    }
    
    func start() {
        let fetchVenuesUseCase: FetchVenuesUseCaseProtocol = FetchVenuesUseCase(venueAPI: venueAPI, localStorageService: localStorageService)
        let updateFavouriteUseCase: UpdateFavouriteUseCaseProtocol = UpdateFavouriteUseCase(localStorageService: localStorageService)
        let viewModel = VenuesViewModel(fetchVenuesUseCase: fetchVenuesUseCase, updateFavouriteUseCase: updateFavouriteUseCase)
        self.venuesViewModel = viewModel
        
        let venuesViewController = VenuesViewController(viewModel: viewModel)
        viewModel.delegate = venuesViewController
        navigationController.pushViewController(venuesViewController, animated: true)
    }
    
    func appDidEnterForeground() {
        venuesViewModel?.startFetchingVenues()
    }
    
    func appDidEnterBackground() {
        venuesViewModel?.stopFetchingTimer()
    }
}

