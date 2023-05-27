//
//  ProfileViewModel.swift
//  Demo_SwitchFromLoginToTabBar
//
//  Created by Илья Сидорик on 27.05.2023.
//

import Foundation

protocol IProfileViewModel: AnyObject {
    var stateChanged: ((ProfileViewModel.State) -> Void)? { get set }
    
    func didTabLoginButton()
}

final class ProfileViewModel {
    
    // MARK: - Enum
    
    enum State {
        case initial
    }
    
    
    // MARK: - Public properties
    
    var stateChanged: ((State) -> Void)?
    
    
    // MARK: - Private properties
    
    private weak var coordinator: IProfileCoordinator?
    
    private var state: State = .initial {
        didSet {
            self.stateChanged?(self.state)
        }
    }
    
    
    // MARK: - Init
    
    init(coordinator: IProfileCoordinator?) {
        self.coordinator = coordinator
    }
    
    deinit {
        print("ProfileViewModel \(#function)")
    }
    
}



    // MARK: - ILoginViewModel

extension ProfileViewModel: IProfileViewModel {
    func didTabLoginButton() {
        self.coordinator?.switchToNextFlow()
    }
}

