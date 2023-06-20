//
//  LoginViewModel.swift
//  Demo_SwitchFromLoginToTabBar
//
//  Created by Илья Сидорик on 27.05.2023.
//

import Foundation
import Combine


final class LoginViewModel {
    
    // MARK: - Enum
    
    enum State {        
        case loading
        case success
        case wrong(text: String)
        case isLoginButtonEnabled(isEnabled: Bool)
        case isValidEmail(isValidEmail: Bool)
        case none
    }
    
    // MARK: - Published
    
    @Published var email = ""
    @Published var pass = ""

    @Published var state: State = .none
    
    
    // MARK: - Private properties
    
    private var cancellables: Set<AnyCancellable> = []
    
    private weak var coordinator: ILoginCoordinator?
    
    
    // MARK: - Init
    
    init(coordinator: ILoginCoordinator?) {
        self.coordinator = coordinator
        self.initInternalPublishers()
    }
    
    deinit {
        print("LoginViewModel \(#function)")
    }
    
    
    // MARK: - Public methods
    
    func didTapLoginButton() {
        self.state = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            if self.isCorrectAuthData() {
                self.coordinator?.switchToNextFlow()
            } else {
                self.state = .wrong(text: "Не верные данные")
            }
        }
    }
    
    
    // MARK: - Private methods
    
    private func isCorrectAuthData() -> Bool {
        return self.email == "Qw@mail.ru" && self.pass == "Qw"
    }
    
    private func initInternalPublishers() {
        // isValidEmail
        $email
            .sink { [weak self] in
                self?.state = .isValidEmail(isValidEmail: $0.isEmail())
            }
            .store(in: &cancellables)
        
        
        // isEnabledButton
        let isLoginButtonEnabled: AnyPublisher<Bool, Never> = Publishers.CombineLatest($email, $pass)
            .map( { $0.isEmail() && !$1.isEmpty } )
            .eraseToAnyPublisher()
        
        isLoginButtonEnabled
            .sink { [weak self] in
                self?.state = .isLoginButtonEnabled(isEnabled: $0)
            }
            .store(in: &self.cancellables)
    }
    
}
