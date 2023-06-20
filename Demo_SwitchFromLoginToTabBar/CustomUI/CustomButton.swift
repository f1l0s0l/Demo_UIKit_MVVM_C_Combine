//
//  CustomButton.swift
//  Demo_SwitchFromLoginToTabBar
//
//  Created by Илья Сидорик on 20.06.2023.
//

import UIKit

final class CustonButton: UIButton {
    
    // MARK: - Public properties
    
    override var isEnabled: Bool {
        didSet {
            self.alpha = isEnabled ? 1.0 : 0.6
        }
    }
    
}
