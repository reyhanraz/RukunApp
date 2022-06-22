//
//  ItemSQLService.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 20/06/22.
//

import Foundation
import RxSwift
struct ItemSQLService: ServiceType{
    
    typealias T = Item
    
    typealias R = Item
    
    func insert(request: Item?) -> Observable<Result<Item, DataAccessError>> {
        guard let request = request else {return .just(.failure(.InvalidRequest))}
        return Observable.create { observer -> Disposable in
            do {
                let item = try ItemDataHelper.insert(item: request)
                observer.onNext(Result<Item, DataAccessError>.success(item))
                observer.onCompleted()
            } catch let error {
                observer.onNext(.failure(error as! DataAccessError))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func update(request: Item?) -> Observable<Result<Item, DataAccessError>> {
        guard let request = request else {return .just(.failure(.InvalidRequest))}
        return Observable.create { observer -> Disposable in
            do {
                let item = try ItemDataHelper.update(item: request)
                observer.onNext(Result<Item, DataAccessError>.success(item))
                observer.onCompleted()
            } catch let error {
                observer.onNext(.failure(error as! DataAccessError))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func delete(request: Item?) -> Observable<Result<Item, DataAccessError>> {
        guard let request = request else {return .just(.failure(.InvalidRequest))}
        return Observable.create { observer -> Disposable in
            do {
                let item = try ItemDataHelper.delete(item: request)
                observer.onNext(Result<Item, DataAccessError>.success(item))
                observer.onCompleted()
            } catch let error {
                observer.onNext(.failure(error as! DataAccessError))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func get(request: String?) -> Observable<Result<Item, DataAccessError>> {
        guard let request = request else {return .just(.failure(.InvalidRequest))}
        return Observable.create { observer -> Disposable in
            do {
                let item = try ItemDataHelper.find(id: request)
                observer.onNext(Result<Item, DataAccessError>.success(item!))
                observer.onCompleted()
            } catch let error {
                observer.onNext(.failure(error as! DataAccessError))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func getAll(request: Item?) -> Observable<Result<[Item], DataAccessError>> {
        return Observable.create { observer -> Disposable in
            do {
                let item = try ItemDataHelper.findAll(id: nil)
                observer.onNext(Result<[Item], DataAccessError>.success(item))
                observer.onCompleted()
            } catch let error {
                observer.onNext(.failure(error as! DataAccessError))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    
}
