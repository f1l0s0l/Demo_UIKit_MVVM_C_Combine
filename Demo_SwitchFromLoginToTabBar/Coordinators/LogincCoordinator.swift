//
//  LogincCoordinator.swift
//  Demo_SwitchFromLoginToTabBar
//
//  Created by Илья Сидорик on 02.03.2023.
//

import UIKit

protocol ILoginCoordinator: AnyObject {
    func switchToNextFlow()
}

final class LoginCoordinator {
    
    // MARK: - Private properties

    private weak var parentCoordinator: IMainCoordinator?
    
    private var navigationController: UIViewController
    
    private var childCoordinators: [ICoordinator] = []
    
    
    // MARK: - Lifecycles

    init(navigationController: UINavigationController, parentCoordinator: IMainCoordinator? ) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
}



    // MARK: - ICoordinator

extension LoginCoordinator: ICoordinator {
    func start() -> UIViewController {
        let viewModel = LoginViewModel(coordinator: self)
        let loginViewController = LoginViewController(viewModel: viewModel)
        let navController = UINavigationController(rootViewController: loginViewController)
        self.navigationController = navController
        
        return self.navigationController
    }
}



    // MARK: - ILoginCoordinator

extension LoginCoordinator: ILoginCoordinator {
    func switchToNextFlow() {
        self.parentCoordinator?.switchToNextFlow(from: self)
    }
}
