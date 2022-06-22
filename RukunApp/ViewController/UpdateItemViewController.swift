//
//  UpdateItemViewController.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 20/06/22.
//

import UIKit

class UpdateItemViewController: BaseViewController {
    
    @IBOutlet weak var nameField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var saveButton: UIButton!
    
    let _viewModel = ItemViewModel(service: ItemSQLService())
    
    var _item: Item?
    
    init(){
        super.init(nibName: "UpdateItemViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        binding()

    }
    
    private func setupView(){
        priceField.setupContent(placeholder: "Price",
                                hint: "Enter Item Price",
                                contentType: .none,
                                keyboardType: .decimalPad,
                                returnKeyType: .done,
                                maxText: 100)
        
        nameField.setupContent(placeholder: "Name",
                                hint: "Enter Item Name",
                                isSecureText: false,
                               contentType: .name,
                                returnKeyType: .next,
                                maxText: 100)
        if let _item = _item {
            nameField.setText(content: _item.name)
            priceField.setText(content: "\(_item.price)")
        }

    }
    
    private func binding(){
        saveButton.rx.tap.subscribe(onNext: { [weak self] _ in
            if let _item = self?._item {
                let item = Item(id: _item.id, name: self?.nameField.getText() ?? "", price: Double(self?.priceField.getText() ?? "0")!, quantity: 0)
                self?._viewModel.update(item: item)
            } else {
                let item = Item(id: nil, name: self?.nameField.getText() ?? "", price: Double(self?.priceField.getText() ?? "0")!, quantity: 0)
                self?._viewModel.update(item: item)
            }
        }).disposed(by: disposeBag)
        
        _viewModel.itemResult.drive(onNext: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
}
