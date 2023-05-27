//
//  LoginViewController.swift
//  Demo_SwitchFromLoginToTabBar
//
//  Created by Илья Сидорик on 02.03.2023.
//

import Foundation
import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let viewModel: ILoginViewModel

    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()
    
    
    // MARK: - Lifecycles
    
    init(viewModel: ILoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.setupView()
        self.setupConstraints()
    }
    
    deinit {
        print("loginViewController \(#function)")
    }
    
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        self.viewModel.stateChanged = { [weak self] state in
            switch state {
            case .initial:
                ()
                // Обрабатываем состояние initial
            }
        }
    }

    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.loginButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.loginButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.loginButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            self.loginButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            self.loginButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc
    private func didTapLoginButton() {
        self.viewModel.didTabLoginButton()
    }
    
}
