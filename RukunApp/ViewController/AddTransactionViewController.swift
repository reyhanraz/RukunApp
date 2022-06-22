//
//  AddTransactionViewController.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 20/06/22.
//

import UIKit

protocol AddTransactionViewControllerDelegate: AnyObject{
    func AddTransactionSuccess(transaction: Transaction)
}

class AddTransactionViewController: BaseViewController {
    private let _cellIdentifier = "ItemsWithStepperTableViewCell"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var totalQuantityLabel: UILabel!
    @IBOutlet weak var transactionType: UISegmentedControl!
    @IBOutlet weak var addButton: UIButton!
    
    weak var delegate: AddTransactionViewControllerDelegate?
    
    let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: nil)
    
    var viewModel = AddTransactionViewModel(date: Date())
    
    var transaction: Transaction?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = saveButton
        title = "Add Transaction"
        
        tableView.register(UINib(nibName: _cellIdentifier, bundle: nil), forCellReuseIdentifier: _cellIdentifier)
        binding()
    }
    
    private func binding(){
        addButton.rx.tap.subscribe(onNext: { _ in
            let vc = ItemListViewController(controllerUsage: .PickItem)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.dismissController))
            vc.navigationItem.leftBarButtonItem = cancelButton
            vc.delegate = self
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true)
        }).disposed(by: disposeBag)
        
        saveButton.rx.tap.subscribe(onNext: { _ in
            self.viewModel.handleSave()
        }).disposed(by: disposeBag)
        
        viewModel.items.bind(to: tableView.rx.items(cellIdentifier: _cellIdentifier, cellType: ItemsWithStepperTableViewCell.self)){ row, item, cell in
            cell.setupContent(index: row, title: item.name, quanity: item.quantity, price: item.price)
            cell.delegate = self
        }.disposed(by: disposeBag)
        
        viewModel.result.drive(onNext: {[weak self] transaction in
            self?.delegate?.AddTransactionSuccess(transaction: transaction)
        }).disposed(by: disposeBag)
        
        viewModel.transactionID.bind(to: idLabel.rx.text).disposed(by: disposeBag)
        viewModel.totalPrice.bind(to: totalPriceLabel.rx.text).disposed(by: disposeBag)
        viewModel.totalQuantity.bind(to: totalQuantityLabel.rx.text).disposed(by: disposeBag)
        viewModel.saveEnabled.bind(to: saveButton.rx.isEnabled).disposed(by: disposeBag)
        
        viewModel.initialState()
    }
    
    @objc private func dismissController(){
        self.dismiss(animated: true)
    }
    
    @IBAction func transactionTypeSegment(_ sender: UISegmentedControl){
        viewModel.changeTransactionType(value: sender.selectedSegmentIndex)
    }
    
}

extension AddTransactionViewController: ItemListViewControllerDelegeate{
    func modelSelected(model: Item) {
        self.dismiss(animated: true)
        viewModel.addItem(item: model)
    }
}

extension AddTransactionViewController: ItemsWithStepperTableViewCellDelegate{
    func quantityUpdated(index: Int, quantity: Int) {
        viewModel.quantityChanged(at: index, quantity: quantity)
    }
}
