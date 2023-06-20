//
//  LoginViewController.swift
//  Demo_SwitchFromLoginToTabBar
//
//  Created by Илья Сидорик on 02.03.2023.
//

import UIKit
import Combine

final class LoginViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let viewModel: LoginViewModel
    
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var loadingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        view.alpha = 0.6
        view.isHidden = true
        return view
    }()
    
    private lazy var activitiIndicator: UIActivityIndicatorView = {
        let indicatior = UIActivityIndicatorView()
        indicatior.translatesAutoresizingMaskIntoConstraints = false
        return indicatior
    }()
    
    private lazy var mailTextFielf: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemGray
        textField.layer.cornerRadius = 10
//        label.text = "Test text"
        return textField
    }()
    
    private lazy var wrongValidEmailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Не валидный email"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        label.textColor = .red
        label.isHidden = true
        return label
    }()

    private lazy var passTextFielf: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemGray
        textField.layer.cornerRadius = 10
//        label.text = "Test text"
        return textField
    }()

    private lazy var loginButton: CustonButton = {
        let button = CustonButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .systemBlue
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.isEnabled = false
        return button
    }()
    
    
    // MARK: - Lifecycles
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        print("loginViewController \(#function)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupConstraints()
        self.setupGestureRecognizer()
        self.bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addObserverToKeyboard()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeObserverToKeyboard()
    }
    
    deinit {
        print("loginViewController \(#function)")
    }
    
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self.mailTextFielf)
            .map { ($0.object as? UITextField)?.text ?? "" }
            .assign(to: \.email, on: self.viewModel)
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self.passTextFielf)
            .map { ($0.object as? UITextField)?.text ?? "" }
            .assign(to: \.pass, on: self.viewModel)
            .store(in: &cancellables)
        
        self.viewModel.$state
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .loading:
                    self.view.endEditing(true)
                    self.loadingView.isHidden = false
                    self.activitiIndicator.startAnimating()
                    
                case .success:
                    self.loadingView.isHidden = true
                    self.activitiIndicator.stopAnimating()
                    
                case .wrong(let text):
                    self.loadingView.isHidden = true
                    self.activitiIndicator.stopAnimating()
                    AlertNotification.shared.presentWrondDefaultNotification(
                        massage: text,
                        for: self
                    )
                    
                case .isLoginButtonEnabled(let isEnabled):
                    self.loginButton.isEnabled = isEnabled
                    
                case .isValidEmail(let isValidEmail):
                    self.wrongValidEmailLabel.isHidden = isValidEmail
                    
                case .none:
                    break
                }
            }
            .store(in: &cancellables)
    }

    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.mailTextFielf)
        self.scrollView.addSubview(self.wrongValidEmailLabel)
        self.scrollView.addSubview(self.passTextFielf)
        self.scrollView.addSubview(self.loginButton)
        self.view.addSubview(self.loadingView)
        self.view.addSubview(self.activitiIndicator)
    }
    
    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.didTapSuperView)
        )
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func addObserverToKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.showKeyboard),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.hideKeyboard),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeObserverToKeyboard() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    
    // MARK: - Constraint
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.mailTextFielf.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 300),
            self.mailTextFielf.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            self.mailTextFielf.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            self.mailTextFielf.heightAnchor.constraint(equalToConstant: 50),
            
            self.wrongValidEmailLabel.topAnchor.constraint(equalTo: self.mailTextFielf.bottomAnchor),
            self.wrongValidEmailLabel.leftAnchor.constraint(equalTo: self.mailTextFielf.leftAnchor),
            self.wrongValidEmailLabel.rightAnchor.constraint(equalTo: self.mailTextFielf.rightAnchor),

            self.passTextFielf.topAnchor.constraint(equalTo: self.wrongValidEmailLabel.bottomAnchor, constant: 10),
            self.passTextFielf.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            self.passTextFielf.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            self.passTextFielf.heightAnchor.constraint(equalToConstant: 50),
            
            self.loginButton.topAnchor.constraint(equalTo: self.passTextFielf.bottomAnchor, constant: 40),
            self.loginButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            self.loginButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            self.loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            self.loadingView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.loadingView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.loadingView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.activitiIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.activitiIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
    
    @objc
    private func didTapLoginButton() {
        self.viewModel.didTapLoginButton()
    }
    
    @objc
    private func didTapSuperView() {
        self.view.endEditing(true)
    }
    
    @objc
    private func showKeyboard(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let loginButtonBottomPointY = self.loginButton.frame.origin.y + self.loginButton.frame.height
        let keyboardOriginY = self.scrollView.frame.height - keyboardHeight
        
        let yOffSet = keyboardOriginY < loginButtonBottomPointY ? loginButtonBottomPointY - keyboardOriginY + 16 : 0
        self.scrollView.setContentOffset(CGPoint(x: .zero, y: yOffSet), animated: true)
    }
    
    @objc
    private func hideKeyboard() {
        self.scrollView.setContentOffset(.zero, animated: true)
    }
    
}
