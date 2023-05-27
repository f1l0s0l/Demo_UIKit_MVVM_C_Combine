//
//  FeedCoordinator.swift
//  Demo_SwitchFromLoginToTabBar
//
//  Created by Илья Сидорик on 02.03.2023.
//

import UIKit

protocol IFeedCoordinator: AnyObject {
    func switchToNextFlow()
}

final class FeedCoordinator {
    
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

extension FeedCoordinator: ICoordinator {
    func start() -> UIViewController {
        let viewModel = FeedViewModel(coordinator: self)
        let feedViewController = FeedViewController(viewModel: viewModel)
        
        let navController = UINavigationController(rootViewController: feedViewController)
        let tabBarItem = UITabBarItem(
            title: "Feed",
            image: UIImage(systemName: "square.stack"),
            tag: 0
        )
        navController.tabBarItem = tabBarItem
        self.navigationController = navController
        
        return self.navigationController
    }
}



    // MARK: - ICoordinator

extension FeedCoordinator: IFeedCoordinator {
    func switchToNextFlow() {
        self.parentCoordinator?.switchToNextFlow()
    }
}
