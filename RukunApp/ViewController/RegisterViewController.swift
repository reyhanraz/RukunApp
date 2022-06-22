//
//  RegisterViewController.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 19/06/22.
//

import UIKit
import RxCocoa
import RxSwift

protocol RegisterViewControllerDelegate: AnyObject{
    func registerDidSuccess()
}

class RegisterViewController: BaseViewController {
    
    @IBOutlet weak var emailField: CustomTextField!
    @IBOutlet weak var passwordField: CustomTextField!
    @IBOutlet weak var nameField: CustomTextField!
    @IBOutlet weak var registerButton: UIButton!
    
    weak var delegate: RegisterViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Register"
        
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
        
        nameField.setupContent(placeholder: "Name",
                                hint: "Enter your Full Name",
                                isSecureText: false,
                               contentType: .name,
                                returnKeyType: .next,
                                maxText: 100)
    }
    
    private func binding(){
        let viewModel = RegisterViewModel(email: emailField.rx.text.orEmpty.asDriver(),
                                          password: passwordField.rx.text.orEmpty.asDriver(),
                                          name: nameField.rx.text.orEmpty.asDriver(),
                                          registerButton: registerButton.rx.tap.asSignal())

        viewModel.submit.drive().disposed(by: disposeBag)
        viewModel.validateName.drive(nameField.rx.validationResult).disposed(by: disposeBag)
        viewModel.validateEmail.drive(emailField.rx.validationResult).disposed(by: disposeBag)
        viewModel.validatePassword.drive(passwordField.rx.validationResult).disposed(by: disposeBag)
        viewModel.registerEnable.drive(registerButton.rx.isEnabled).disposed(by: disposeBag)

        viewModel.failed.drive(rx.failed).disposed(by: disposeBag)

        viewModel.result.drive(onNext: {[weak self] failed in
            self?.delegate?.registerDidSuccess()
        }).disposed(by: disposeBag)

    }

}
