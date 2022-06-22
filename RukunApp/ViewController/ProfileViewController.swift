//
//  ProfileViewController.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 19/06/22.
//

import UIKit
import FirebaseAuth
import RxSwift

protocol ProfileViewControllerDelegate: AnyObject{
    func signOutDidTap()
}

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    
    weak var delegate: ProfileViewControllerDelegate?
    
    private let _preference = Preference()
    private var _user: User? {
        didSet{
            idLabel.text = _user?.id
            nameLabel.text = _user?.name
            emailLabel.text = _user?.email
        }
    }
    let firebaseAuth = Auth.auth()


    override func viewDidLoad() {
        super.viewDidLoad()
                        
        title = "Profile"
        
        binding()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadData()
    }
    
    private func loadData(){
        _user = _preference.getUser()
    }
    
    private func binding(){
        signOutButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.showAlert(title: "Sign Out", message: "Are you sure want to Sign Out?", okHandler: { 
                self?.signOut()
                
            })
        }).disposed(by: disposeBag)
    }
    
    private func signOut(){
        do {
            try self.firebaseAuth.signOut()
            self._preference.clearDefault()
            self.delegate?.signOutDidTap()
        } catch let signOutError as NSError {
            self.showToast(message: "Error signing out: \(signOutError)")
        }
    }
}
