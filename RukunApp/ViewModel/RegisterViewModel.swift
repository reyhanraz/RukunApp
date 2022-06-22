//
//  RegisterViewModel.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 19/06/22.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

struct RegisterViewModel{
    
    let validateEmail: Driver<ValidationResult>
    let validatePassword: Driver<ValidationResult>
    let validateName: Driver<ValidationResult>
    
    let result: Driver<User>
    let failed: Driver<String>
    let submit: Driver<()>
    
    let registerEnable: Driver<Bool>

    init(email: Driver<String>, password: Driver<String>, name: Driver<String>, registerButton: Signal<()>){
        let _failed = PublishSubject<String>()
        let _result = PublishSubject<User>()
        
        failed = _failed.asDriver(onErrorDriveWith: .empty())
        result = _result.asDriver(onErrorDriveWith: .empty())
        
        let auth = Auth.auth()
        
        validateName = name.flatMap({ name in
            if name.isEmpty {
                return .just(.empty)
            } else {
                return .just(.ok(message: nil))
            }
        })

        validateEmail = email.flatMap({ email in
            if email.isEmpty {
                return .just(.empty)
            } else if !email.isValidEmail {
                return .just(.failed(message: "Please Enter Valid Email"))
            } else {
                return .just(.ok(message: nil))
            }
        })
        
        validatePassword = password.flatMap({ password in
            if password.isEmpty {
                return .just(.empty)
            } else if !password.validPassword {
                return .just(.failed(message: "Minimum 8 characters (no spaces), at least 1 letter and 1 number"))
            } else {
                return .just(.ok(message: nil))
            }
        })
        
        registerEnable = Driver.combineLatest(validateEmail, validatePassword){ email, password in
            email.isValid && password.isValid
        }
        
        let form = Driver.combineLatest(name, email, password){name, email, password in
            (name, email, password)
        }
        
        submit = registerButton.withLatestFrom(form).flatMapLatest({name, email, password in
            auth.createUser(withEmail: email, password: password) { result, error in
                if let error = error{
                    _failed.onNext(error.localizedDescription)
                    return
                }
                let change = result?.user.createProfileChangeRequest()
                change?.displayName = name
                change?.commitChanges(completion: { error in
                    if let error = error{
                        _failed.onNext(error.localizedDescription)
                        return
                    }
                })
                
                let user = User(id: result?.user.uid, name: result?.user.displayName, email: result?.user.email)
                _result.onNext(user)

            }
            return .empty()
        })
    }
}
