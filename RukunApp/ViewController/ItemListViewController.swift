//
//  ItemViewController.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 20/06/22.
//

import UIKit
import RxSwift

protocol ItemListViewControllerDelegeate: AnyObject{
    func modelSelected(model: Item)
}

class ItemListViewController: BaseViewController {
    
    enum ControllerUsage{
        case manageItem
        case PickItem
    }
    @IBOutlet weak var tableView: UITableView!
    let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: nil)

    private let _cellIdentifier = "ItemCell"
    let _viewModel = ItemViewModel(service: ItemSQLService())
    let controllerUsage: ControllerUsage
    weak var delegate: ItemListViewControllerDelegeate?
    
    init(controllerUsage: ControllerUsage){
        self.controllerUsage = controllerUsage
        super.init(nibName: "ItemListViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ItemsTableViewCell", bundle: nil), forCellReuseIdentifier: _cellIdentifier)
        
        if controllerUsage == .manageItem {
            navigationItem.rightBarButtonItem = addButton
        }
        
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func binding(){
        _viewModel.result.drive(tableView.rx.items(cellIdentifier: _cellIdentifier, cellType: ItemsTableViewCell.self)){ row, model, cell in
            cell.setupContent(cellType: .Item(index: row, title: model.name, quanity: model.quantity, price: model.price))
        }.disposed(by: disposeBag)
        
        switch controllerUsage {
        case .manageItem:
            addButton.rx.tap.subscribe(onNext: { _ in
                let vc = UpdateItemViewController()
                vc.title = "Add Item"
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
            
            _viewModel.deletedItem.drive(onNext: {[weak self] _ in
                self?._viewModel.getAll()
            }).disposed(by: disposeBag)
            
            tableView.rx.modelDeleted(Item.self).subscribe(onNext: {[weak self] item in
                self?._viewModel.delete(item: item)
            }).disposed(by: disposeBag)
            
            tableView.rx.modelSelected(Item.self).subscribe(onNext: { item in
                let vc = UpdateItemViewController()
                vc.title = "Update Item"
                self.navigationController?.pushViewController(vc, animated: true)
                vc._item = item
            }).disposed(by: disposeBag)
            
        case .PickItem:
            tableView.rx.modelSelected(Item.self).subscribe(onNext: { item in
                self.delegate?.modelSelected(model: item)
            }).disposed(by: disposeBag)
        }
    }
    
    func loadData(){
        _viewModel.getAll()
    }

}
