//
//  ProfileViewController.swift
//  Demo_SwitchFromLoginToTabBar
//
//  Created by Илья Сидорик on 27.05.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Provate properties
    
    private let viewModel: IProfileViewModel
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        button.setTitle("Log Out", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()
    
    // MARK: - Lifecycles
    
    init(viewModel: IProfileViewModel) {
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
        print("ProfileViewController \(#function)")
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
        self.title = "Profile"
        self.view.backgroundColor = .white
        self.view.addSubview(self.logoutButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.logoutButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.logoutButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            self.logoutButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            self.logoutButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc
    private func didTapLogoutButton() {
        self.viewModel.didTabLoginButton()
    }

}


