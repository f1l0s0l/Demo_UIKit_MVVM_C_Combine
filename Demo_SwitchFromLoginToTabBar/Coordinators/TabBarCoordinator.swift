//
//  TabBarCoordinator.swift
//  Demo_SwitchFromLoginToTabBar
//
//  Created by Илья Сидорик on 02.03.2023.
//

import UIKit

protocol ITabBarCoordinator: AnyObject {
    func switchToNextFlow()
}

final class TabBarCoordinator {
    
    // MARK: - Private properties

    private weak var parentCoordinator: IMainCoordinator?
    
    private var tabBarController: UITabBarController
    
    private var childCoordinators: [ICoordinator] = []
    
    
    // MARK: - Lifecycles

    init(tabBarController: UITabBarController, parentCoordinator: IMainCoordinator?) {
        self.tabBarController = tabBarController
        self.parentCoordinator = parentCoordinator
    }
    
    
    // MARK: - Private methods

    private func makeFeedCoordinator() -> ICoordinator {
        let feedCoordinator = FeedCoordinator(
            navigationController: UINavigationController(),
            parentCoordinator: self
        )
        
        return feedCoordinator
    }
    
    private func makeProfileCoordinator() -> ICoordinator {
        let profileCoordinator = ProfileCoordinator(
            navigationController: UINavigationController(),
            parentCoordinator: self
        )
        
        return profileCoordinator
    }
    
    private func setupTabBarController(viewControllers: [UIViewController]) {
        self.tabBarController.setViewControllers(viewControllers, animated: false)
        self.tabBarController.tabBar.backgroundColor = .white
        self.tabBarController.tabBar.tintColor = .black
    }
    
    private func addChildCoordinator(_ coordinator: ICoordinator) {
        guard !self.childCoordinators.contains(where: { $0 === coordinator }) else {
            return
        }
        self.childCoordinators.append(coordinator)
    }
    
    private func removeChildCoordinator(_ coordinator: ICoordinator) {
        self.childCoordinators.removeAll(where: {$0 === coordinator})
    }
  
}



    // MARK: - ICoordinator

extension TabBarCoordinator: ICoordinator {
    func start() -> UIViewController {
        let feedCoordinator = self.makeFeedCoordinator()
        self.addChildCoordinator(feedCoordinator)
        
        let profileCoordinator = self.makeProfileCoordinator()
        self.addChildCoordinator(profileCoordinator)

        self.setupTabBarController(viewControllers: [
            feedCoordinator.start(),
            profileCoordinator.start()
        ])
                
        return self.tabBarController
    }
}



    // MARK: - ITabBarCoordinator

extension TabBarCoordinator: ITabBarCoordinator {
    func switchToNextFlow() {
        self.parentCoordinator?.switchToLogin()
    }

}
