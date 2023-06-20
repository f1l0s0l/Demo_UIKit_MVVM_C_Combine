//
//  MainCoordinator.swift
//  Demo_SwitchFromLoginToTabBar
//
//  Created by Илья Сидорик on 02.03.2023.
//

import UIKit

protocol IMainCoordinator: AnyObject {
    func switchToTabBar()
    func switchToLogin()
}

final class MainCoordinator {
    
    // MARK: - Private properties
    
    private var rootViewController: UIViewController
   
    private var childCoordinators: [ICoordinator] = []
    
    
    // MARK: - Lifecycles
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    
    // MARK: - Private methods
    
    private func makeLoginCoordinator() -> ICoordinator {
        let loginCoordinator = LoginCoordinator(
            navigationController: UINavigationController(),
            parentCoordinator: self
        )
        return loginCoordinator
    }
    
    private func makeToTabBarCoordinator() -> ICoordinator {
        let tabBarCoordinator = TabBarCoordinator(
            tabBarController: UITabBarController(),
            parentCoordinator: self
        )
        return tabBarCoordinator
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
    
    // Методы установки/переключения Flow
    private func setFlow(to newViewController: UIViewController) {
        self.rootViewController.addChild(newViewController)
        newViewController.view.frame = self.rootViewController.view.bounds
        self.rootViewController.view.addSubview(newViewController.view)
        newViewController.didMove(toParent: self.rootViewController)
    }
    
    private func switchFlow(to newViewController: UIViewController) {
        self.rootViewController.children[0].willMove(toParent: nil)
        self.rootViewController.children[0].navigationController?.navigationBar.isHidden = true
        self.rootViewController.addChild(newViewController)
        newViewController.view.frame = self.rootViewController.view.bounds
        
        self.rootViewController.transition(
            from: self.rootViewController.children[0],
            to: newViewController,
            duration: 0.6,
            options: [.transitionCrossDissolve, .curveEaseOut],
            animations: {}
        ) { _ in
            self.rootViewController.children[0].removeFromParent()
            newViewController.didMove(toParent: self.rootViewController)
            }
    }
    
    private func switchCoordinators(from oldCoordinator: ICoordinator, to newCoordinator: ICoordinator) {
        self.addChildCoordinator(newCoordinator)
        self.switchFlow(to: newCoordinator.start())
        self.removeChildCoordinator(oldCoordinator)
    }
    
}



    // MARK: - ICoordinator

extension MainCoordinator: ICoordinator {
    
    func start() -> UIViewController {
        var coordinator: ICoordinator
        // Тут проверка:
//        if пользователь авторизирован {
//            coordinator = self.makeToTabBarCoordinator()
//        } else {
//            coordinator = self.makeLoginCoordinator()
//        }
        // Для примера, пользователь не авторизирован:
        coordinator = self.makeLoginCoordinator()
        self.addChildCoordinator(coordinator)
        self.setFlow(to: coordinator.start())
        return self.rootViewController
    }
}



    // MARK: - CoordinatbleMain

extension MainCoordinator: IMainCoordinator {
    
    func switchToTabBar() {
        let tabBatCoordinator = self.makeToTabBarCoordinator()
        self.addChildCoordinator(tabBatCoordinator)
        self.switchFlow(to: tabBatCoordinator.start())
        self.removeChildCoordinator(self.childCoordinators[0])
    }
    
    func switchToLogin() {
        let loginCoordinator = self.makeLoginCoordinator()
        self.addChildCoordinator(loginCoordinator)
        self.switchFlow(to: loginCoordinator.start())
        self.removeChildCoordinator(self.childCoordinators[0])
    }

}
