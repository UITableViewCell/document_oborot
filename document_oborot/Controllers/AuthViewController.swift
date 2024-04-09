//
//  AuthViewController.swift
//  document_oborot
//
//  Created by 123 on 07.04.2024.
//

import UIKit

class AuthViewController: UIViewController {
    
    
    
    // MARK: - Properties
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.text = "123456"
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - View Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupViews()
        setupConstraints()
        
        // Do any additional setup after loading the view.
    }
    
    deinit {
         print("deinit")
     }

    
    
    // MARK: - Setup
    
    func setupViews() {
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            usernameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    // MARK: - Actions
    
    @objc func loginButtonTapped() {
        FirebaseManager.shared.loginUser(user: UserData(login: usernameTextField.text!, password: passwordTextField.text!)) {[weak self] role in
            switch role {
            case "director":
                DispatchQueue.main.async {
                    self?.navigationController?.pushViewController(DirectorViewController(), animated: true)
                    self?.navigationController?.viewControllers.remove(at: 0)
                }
            case "head_of_department":
                DispatchQueue.main.async {
                    self?.navigationController?.pushViewController(HeadOfDepartmentViewController(), animated: true)
                    self?.navigationController?.viewControllers.remove(at: 0)
                }
            case "department_worker":
                DispatchQueue.main.async {
                    self?.navigationController?.pushViewController(DepartmentWorkerViewController(), animated: true)
                    self?.navigationController?.viewControllers.remove(at: 0)
                }
            default: return
            }
            
        }
        

    }
    
    
    private func login() {
        
    }
    
    
    
    
    
}
