//
//  ProfileCoordinator.swift
//  Demo_SwitchFromLoginToTabBar
//
//  Created by Илья Сидорик on 02.03.2023.
//

import UIKit

protocol IProfileCoordinator: AnyObject {
    func switchToNextFlow()
}

final class ProfileCoordinator {
    
    // MARK: - Private properties
    
    private var navigationController: UINavigationController
    
    private weak var parentCoordinator: ITabBarCoordinator?
    
    
    // MARK: - Init
    
    init(navigationController: UINavigationController, parentCoordinator: ITabBarCoordinator?) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
}



    // MARK: - ICoordinator

extension ProfileCoordinator: ICoordinator {
    func start() -> UIViewController {
        let viewModel = ProfileViewModel(coordinator: self)
        let profileViewController = ProfileViewController(viewModel: viewModel)
        
        let navController = UINavigationController(rootViewController: profileViewController)
        let tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            tag: 1
        )
        navController.tabBarItem = tabBarItem
        self.navigationController = navController
        
        return self.navigationController
    }
}



    // MARK: - IProfileCoordinator

extension ProfileCoordinator: IProfileCoordinator {
    func switchToNextFlow() {
        self.parentCoordinator?.switchToNextFlow()
    }
}

