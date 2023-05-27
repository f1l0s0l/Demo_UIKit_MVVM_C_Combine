//
//  LoginViewModel.swift
//  Demo_SwitchFromLoginToTabBar
//
//  Created by Илья Сидорик on 27.05.2023.
//

import Foundation

protocol ILoginViewModel: AnyObject {
    var stateChanged: ((LoginViewModel.State) -> Void)? { get set }
    
    func didTabLoginButton()
}

final class LoginViewModel {
    
    // MARK: - Enum
    
    enum State {
        case initial
    }
    
    
    // MARK: - Public properties
    
    var stateChanged: ((State) -> Void)?
    
    
    // MARK: - Private properties
    
    private weak var coordinator: ILoginCoordinator?
    
    private var state: State = .initial {
        didSet {
            self.stateChanged?(self.state)
        }
    }
    
    
    // MARK: - Init
    
    init(coordinator: ILoginCoordinator?) {
        self.coordinator = coordinator
    }
    
    deinit {
        print("LoginViewModel \(#function)")
    }
    
}



    // MARK: - ILoginViewModel

extension LoginViewModel: ILoginViewModel {
    func didTabLoginButton() {
        self.coordinator?.switchToNextFlow()
    }
}
