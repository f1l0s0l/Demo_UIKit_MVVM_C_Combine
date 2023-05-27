//
//  ProtocolCoordinator.swift
//  Demo_SwitchFromLoginToTabBar
//
//  Created by Илья Сидорик on 02.03.2023.
//

import UIKit

protocol ICoordinator: AnyObject {
//    var childCoordinators: [ICoordinator] { get }
    func start() -> UIViewController
//    func addChildCoordinator(_ coordinator: ICoordinator)
//    func removeChildCoordinator(_ coordinator: ICoordinator)
}

