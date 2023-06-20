//
//  String+Extension.swift
//  Demo_SwitchFromLoginToTabBar
//
//  Created by Илья Сидорик on 20.06.2023.
//

import Foundation

extension String {
    
    struct EmailValidation {
//        private static let firstPart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        
        private static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        static let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    }
    
    func isEmail() -> Bool {
        return EmailValidation.emailPredicate.evaluate(with: self)
    }
}
