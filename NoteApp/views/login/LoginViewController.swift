//
//  LoginViewController.swift
//  NoteApp
//
//  Created by דוד נוי on 06/06/2024.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var saveLoginSwitch: UISwitch!
    @IBOutlet private weak var toggleLabel: UILabel!

    private var isLoginMode = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @IBAction func loginRegisterAction(_ sender: UIButton) {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: Strings.enterBothPasswordAndUserName)
            return
        }
        
        if isLoginMode {
            login(username: username, password: password)
        } else {
            register(username: username, password: password)
        }
    }
    
    func setupUI() {
        titleLabel.text = Strings.login
        toggleLabel.text = Strings.switchToRegister
        loginButton.setTitle(Strings.login, for: .normal)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleLoginRegister))
        toggleLabel.isUserInteractionEnabled = true
        toggleLabel.addGestureRecognizer(tapGesture)
    }

    func login(username: String, password: String) {
        if let savedPassword = UserDefaults.standard.string(forKey: username),
           savedPassword == password {
            if saveLoginSwitch.isOn {
                UserDefaults.standard.set(true, forKey: Strings.isLoggedInKey)
                UserDefaults.standard.set(username, forKey: Strings.cachedUsername)
            }
            navigateToMainApp()
        } else {
            showAlert(message: Strings.invalidUsernameOrPassword)
        }
    }
    
    func register(username: String, password: String) {
        if UserDefaults.standard.string(forKey: username) == nil {
            UserDefaults.standard.set(password, forKey: username)
            if saveLoginSwitch.isOn {
                UserDefaults.standard.set(true, forKey: Strings.isLoggedInKey)
                UserDefaults.standard.set(username, forKey: Strings.cachedUsername)
            }
            navigateToMainApp()
        } else {
            showAlert(message: Strings.usernameAlreadyExists)
        }
    }
    
    func navigateToMainApp() {
        if let mainTabBarController = UIStoryboard(name: Strings.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: Strings.mainTabBarController) as? UITabBarController {
            mainTabBarController.modalPresentationStyle = .fullScreen
            present(mainTabBarController, animated: true, completion: nil)
        } else {
            showAlert(message: Strings.navProblem)
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.ok, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Toggle between Login and Register mode
    @objc func toggleLoginRegister() {
        isLoginMode.toggle()
        if isLoginMode {
            titleLabel.text = Strings.login
            toggleLabel.text = Strings.switchToRegister
            loginButton.setTitle(Strings.login, for: .normal)
        } else {
            titleLabel.text = Strings.register
            toggleLabel.text = Strings.switchToLogin
            loginButton.setTitle(Strings.register, for: .normal)
        }
    }
}

