//
//  TransactionViewController.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 20/06/22.
//

import UIKit

class TransactionViewController: BaseViewController {

    private let _cellIdentifier = "ItemCell"
    @IBOutlet weak var tableView: UITableView!
    
    let _viewModel = TransactionViewModel(service: TransactionSQLService())
    
    let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ItemsTableViewCell", bundle: nil), forCellReuseIdentifier: _cellIdentifier)
        
        navigationItem.rightBarButtonItem = addButton
        
        title = "Manage Transaction"
        
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func binding(){
        
        addButton.rx.tap.subscribe(onNext: { _ in
            let vc = AddTransactionViewController()
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        _viewModel.result.drive(tableView.rx.items(cellIdentifier: _cellIdentifier, cellType: ItemsTableViewCell.self)){ row, model, cell in
            cell.setupContent(cellType: .Transaction(index: row, title: model.id, date: model.date.toMediumDateString, price: model.totalPrice ?? 0))
        }.disposed(by: disposeBag)
        
        _viewModel.insertResult.drive(onNext: { [weak self] _ in
            self?.loadData()
        }).disposed(by: disposeBag)
    }
    
    func loadData(){
        _viewModel.getAll()
    }

}

extension TransactionViewController: AddTransactionViewControllerDelegate{
    func AddTransactionSuccess(transaction: Transaction) {
        navigationController?.popToViewController(self, animated: true)
        _viewModel.insert(item: transaction)
    }
}
