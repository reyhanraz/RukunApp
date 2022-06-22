//
//  BaseViewController.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 17/06/22.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    enum ToastType{
        case success
        case error
    }
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let endEditing = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        endEditing.cancelsTouchesInView = false
        view.addGestureRecognizer(endEditing)

    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil, okHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            okHandler?()
        }))
       
        present(alert, animated: true, completion: completion)
    }
    
    func showToast(message: String, toastType: ToastType = .error, completion: ( () -> Void)?  = nil) {
        let toastContainer = UIView(frame: CGRect())
        switch toastType {
        case .error:
            toastContainer.backgroundColor = UIColor.red
        case .success:
            toastContainer.backgroundColor = UIColor(red: 0.439, green: 0.749, blue: 0, alpha: 1)
        }
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 8;
        toastContainer.clipsToBounds  =  true

        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .left;
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0

        toastContainer.addSubview(toastLabel)
        self.view.addSubview(toastContainer)

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 16)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -16)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -12)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 12)
        toastContainer.addConstraints([a1, a2, a3, a4])

        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 15)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -16)
        let c3: NSLayoutConstraint
        if #available(iOS 11, *) {
          let guide = view.safeAreaLayoutGuide
            c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: guide, attribute: .bottom, multiplier: 1, constant: -40)
        } else {
            c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -40)
        }
        self.view.addConstraints([c1, c2, c3])

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 3, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
                completion?()
            })
        })
    }
    
    func keyboardHeight() -> Observable<CGFloat> {
        return Observable
            .from([
                NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                            .map { notification -> CGFloat in
                                (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                            },
                NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                            .map { _ -> CGFloat in
                                0
                            }
            ])
            .merge()
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }

}

extension Reactive where Base: BaseViewController{
    var failed: Binder<String>{
        return Binder(self.base) { view, result in
            view.showToast(message: result)
        }
    }
}
