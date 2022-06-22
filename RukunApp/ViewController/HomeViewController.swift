//
//  HomeViewController.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 19/06/22.
//

import UIKit
import FirebaseAuth
import RxSwift

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var manageItemButton: UIButton!
    @IBOutlet weak var manageTransactionButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        if Auth.auth().currentUser == nil {
            presentLogin()
        }
        
        binding()

    }
    
    private func binding(){
        manageItemButton.rx.tap.subscribe(onNext: { [weak self] _ in
            let vc = ItemListViewController(controllerUsage: .manageItem)
            vc.title = "Manage Items"
            vc.hidesBottomBarWhenPushed = true
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        manageTransactionButton.rx.tap.subscribe(onNext: { [weak self] _ in
            let vc = TransactionViewController()
            vc.hidesBottomBarWhenPushed = true
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }
    
    
    private func presentLogin(){
        let vc = LoginViewController()
        let nav = UINavigationController(rootViewController: vc)
        
        vc.delegate = self
        
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }

}

extension HomeViewController: LoginViewControllerDelegate{
    func loginDidSuccess() {
        self.dismiss(animated: true)
    }
}

extension HomeViewController: ProfileViewControllerDelegate{
    func signOutDidTap() {
        self.tabBarController?.selectedIndex = 0
        presentLogin()
    }
}
