//
//  AlertNotification.swift
//  Demo_SwitchFromLoginToTabBar
//
//  Created by Илья Сидорик on 20.06.2023.
//

import UIKit

final class AlertNotification {
    
    static let shared = AlertNotification()
    
    func presentWrondDefaultNotification(massage: String, for viewController: UIViewController) {
        let alertController = UIAlertController(
            title: "Ошибка",
            message: massage,
            preferredStyle: .alert
        )
        let alertOk = UIAlertAction(
            title: "Ок",
            style: .cancel
        )
        alertController.addAction(alertOk)
        
        viewController.present(alertController, animated: true)
    }
    
}
