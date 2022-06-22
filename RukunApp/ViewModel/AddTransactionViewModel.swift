//
//  AddTransactionViewModel.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 20/06/22.
//

import Foundation
import RxSwift
import RxCocoa

class AddTransactionViewModel{
    
    let transactionID = PublishSubject<String?>()
    let items = PublishSubject<[Item]>()
    let totalPrice = PublishSubject<String>()
    let totalQuantity = PublishSubject<String>()
    let saveEnabled = PublishSubject<Bool>()
    var result: Driver<Transaction>
    private let transactionType = PublishSubject<Int>()
    
    private let submitProperty = PublishSubject<Void>()
    
    private let _date: Date


    private var _items = [Item]()
    
    init(date: Date){
        _date = date
        
        let form = Driver.combineLatest(items.asDriver(onErrorDriveWith: .empty()), transactionType.asDriver(onErrorDriveWith: .empty())) {items, type -> Transaction in
            
            var details = [TransactionDetail]()
            
            for _item in items {
                var qty = _item.quantity
                if type == 0 {
                    qty.negate()
                }
                
                let _detail = TransactionDetail(transactionID: date.toID,
                                                itemID: _item.id!,
                                                quantity: qty,
                                                itemPrice: _item.price)
                details.append(_detail)
            }
            
            return Transaction(id: date.toID, date: date, details: details)
        }
        
        result = submitProperty.asDriver(onErrorDriveWith: .empty()).withLatestFrom(form)
    }
    
    func initialState(){
        items.onNext([])
        totalPrice.onNext("0")
        totalQuantity.onNext("0")
        saveEnabled.onNext(false)
        transactionType.onNext(0)
        transactionID.onNext(_date.toID)
    }
    
    func handleSave(){
        submitProperty.onNext(())
    }
    
    func addItem(item: Item){
        if let index = _items.firstIndex(where: {$0.id == item.id}){
            _items[index].quantity += 1
            items.onNext(_items)
            countTotal()
        } else {
            let newItem = Item(id: item.id, name: item.name, price: item.price, quantity: 1)
            _items.append(newItem)
            items.onNext(_items)
            countTotal()
        }
    }
    
    func removeItem(at Index: Int){
        _items.remove(at: Index)
        items.onNext(_items)
        countTotal()
    }
    
    func quantityChanged(at: Int, quantity: Int){
        guard quantity > 0 else {
            _items.remove(at: at)
            items.onNext(_items)
            countTotal()
            return
        }
        _items[at].quantity = quantity
        items.onNext(_items)
        countTotal()
    }
    
    func changeTransactionType(value: Int){
        transactionType.onNext(value)
    }
    
    private func countTotal(){
        var price = 0.0
        var qty = 0
        for item in _items {
            qty += item.quantity
            price += item.price * Double(item.quantity)
        }
        totalQuantity.onNext("\(qty)")
        totalPrice.onNext("\(price)")
        saveEnabled.onNext(price > 0)
    }
}
