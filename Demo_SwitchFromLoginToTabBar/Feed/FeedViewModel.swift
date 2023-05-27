//
//  FeedViewModel.swift
//  Demo_SwitchFromLoginToTabBar
//
//  Created by Илья Сидорик on 27.05.2023.
//

import Foundation

protocol IFeedViewModel: AnyObject {
    var stateChanged: ((FeedViewModel.State) -> Void)? { get set }
    
    func didTabLoginButton()
}

final class FeedViewModel {
    
    // MARK: - Enum
    
    enum State {
        case initial
    }
    
    
    // MARK: - Public properties
    
    var stateChanged: ((State) -> Void)?
    
    
    // MARK: - Private properties
    
    private weak var coordinator: IFeedCoordinator?
    
    private var state: State = .initial {
        didSet {
            self.stateChanged?(self.state)
        }
    }
    
    
    // MARK: - Init
    
    init(coordinator: IFeedCoordinator?) {
        self.coordinator = coordinator
    }
    
    deinit {
        print("FeedViewModel \(#function)")
    }
    
}



    // MARK: - ILoginViewModel

extension FeedViewModel: IFeedViewModel {
    func didTabLoginButton() {
        self.coordinator?.switchToNextFlow()
    }
}
