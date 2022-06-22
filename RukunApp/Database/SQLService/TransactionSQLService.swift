//
//  TransactionSQLService.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 20/06/22.
//

import Foundation
import RxSwift
struct TransactionSQLService: ServiceType{
    
    typealias T = Transaction
    
    typealias R = Transaction
    
    func insert(request: R?) -> Observable<Result<T, DataAccessError>> {
        guard let request = request else {return .just(.failure(.InvalidRequest))}
        return Observable.create { observer -> Disposable in
            do {
                let transaction = try TransactionDataHelper.insert(item: request)
                for details in request.details{
                    _ = try TransactionDetailDataHelper.insert(item: details)
                    _ = try ItemDataHelper.updateQty(id: details.itemID, quantity: details.quantity)
                }
                observer.onNext(Result<T, DataAccessError>.success(transaction))
                observer.onCompleted()
            } catch let error {
                observer.onNext(.failure(error as! DataAccessError))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func update(request: R?) -> Observable<Result<T, DataAccessError>> {
        guard let request = request else {return .just(.failure(.InvalidRequest))}
        return Observable.create { observer -> Disposable in
            do {
                let transaction = try TransactionDataHelper.update(item: request)
                observer.onNext(Result<T, DataAccessError>.success(transaction))
                observer.onCompleted()
            } catch let error {
                observer.onNext(.failure(error as! DataAccessError))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func delete(request: R?) -> Observable<Result<T, DataAccessError>> {
        guard let request = request else {return .just(.failure(.InvalidRequest))}
        return Observable.create { observer -> Disposable in
            do {
                let transaction = try TransactionDataHelper.delete(item: request)
                observer.onNext(Result<T, DataAccessError>.success(transaction))
                observer.onCompleted()
            } catch let error {
                observer.onNext(.failure(error as! DataAccessError))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func get(request: String?) -> Observable<Result<T, DataAccessError>> {
        guard let request = request else {return .just(.failure(.InvalidRequest))}
        return Observable.create { observer -> Disposable in
            do {
                let transaction = try TransactionDataHelper.find(id: request)
                observer.onNext(Result<T, DataAccessError>.success(transaction!))
                observer.onCompleted()
            } catch let error {
                observer.onNext(.failure(error as! DataAccessError))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func getAll(request: R?) -> Observable<Result<[T], DataAccessError>> {
        return Observable.create { observer -> Disposable in
            do {
                let transaction = try TransactionDataHelper.findAll(id: nil)
                observer.onNext(Result<[T], DataAccessError>.success(transaction))
                observer.onCompleted()
            } catch let error {
                observer.onNext(.failure(error as! DataAccessError))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    
}
