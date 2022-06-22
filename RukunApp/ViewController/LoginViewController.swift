//
//  LoginViewController.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 17/06/22.
//

import UIKit
import RxSwift
import RxCocoa

protocol LoginViewControllerDelegate: AnyObject{
    func loginDidSuccess()
}

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var emailField: CustomTextField!
    @IBOutlet weak var passwordField: CustomTextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!

    private let _preference = Preference()
    weak var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        
        setupView()
        
        binding()

    }
    
    private func setupView(){
        emailField.setupContent(placeholder: "Email",
                                hint: "Enter your Email",
                                contentType: .emailAddress,
                                keyboardType: .emailAddress,
                                returnKeyType: .next,
                                maxText: 100)
        
        passwordField.setupContent(placeholder: "Password",
                                hint: "Enter your Password",
                                isSecureText: true,
                                contentType: .password,
                                returnKeyType: .done,
                                maxText: 100)
    }
    
    private func binding(){
        let viewModel = LoginViewModel(email: emailField.rx.text.orEmpty.asDriver(), password: passwordField.rx.text.orEmpty.asDriver(), signInButton: signInButton.rx.tap.asSignal())
        
        viewModel.submit.drive().disposed(by: disposeBag)
        viewModel.validateEmail.drive(emailField.rx.validationResult).disposed(by: disposeBag)
        viewModel.validatePassword.drive(passwordField.rx.validationResult).disposed(by: disposeBag)
        viewModel.loginEnable.drive(signInButton.rx.isEnabled).disposed(by: disposeBag)
        
        viewModel.failed.drive(rx.failed).disposed(by: disposeBag)
        
        viewModel.result.drive(onNext: {[weak self] user in
            self?._preference.save(user: user)
            self?.delegate?.loginDidSuccess()
        }).disposed(by: disposeBag)
        
        registerButton.rx.tap.subscribe(onNext: { [weak self] _ in
            let vc = RegisterViewController()
            vc.delegate = self
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }
}

extension LoginViewController: RegisterViewControllerDelegate{
    func registerDidSuccess() {
        self.navigationController?.popToViewController(self, animated: true)
    }
}
