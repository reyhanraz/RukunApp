//
//  ItemViewModel.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 20/06/22.
//

import Foundation
import RxSwift
import RxCocoa


struct ItemViewModel{
    typealias T = Item
    let result: Driver<[T]>
    let itemResult: Driver<T>
    let deletedItem: Driver<T>
    
    private let _getList = PublishSubject<Void>()
    private let _update = PublishSubject<Item>()
    private let _delete = PublishSubject<Item>()


        
    init<Service: ServiceType>(service: Service) where Service.T == T, Service.R == T{
        
        result = _getList.asDriver(onErrorDriveWith: .empty())
            .flatMapLatest({ _ in
                service.getAll(request: nil).asDriver(onErrorDriveWith: .empty())
            }).flatMapLatest({ result in
                switch result{
                    
                case .success(let items):
                    return .just(items)
                case .failure(_):
                    break
                }
                return .empty()
            })
        
        itemResult = _update.asDriver(onErrorDriveWith: .empty())
            .flatMapLatest({ request -> Driver<Result<T, DataAccessError>> in
                let service = request.id == nil ? service.insert(request: request) : service.update(request: request)
                return service.asDriver(onErrorDriveWith: .empty())
                
            }).flatMapLatest({ result in
                switch result{
                    
                case .success(let item):
                    return .just(item)
                case .failure(_):
                    break
                }
                return .empty()
            })
        
        deletedItem = _delete.asDriver(onErrorDriveWith: .empty())
            .flatMapLatest({ request -> Driver<Result<T, DataAccessError>> in
                
                return service.delete(request: request).asDriver(onErrorDriveWith: .empty())
                
            }).flatMapLatest({ result in
                switch result{
                    
                case .success(let item):
                    return .just(item)
                case .failure(_):
                    break
                }
                return .empty()
            })
        
        
    }
    
    func getAll(){
        _getList.onNext(())
    }
    
    func update(item: Item){
        _update.onNext(item)
    }
    
    func delete(item: Item){
        _delete.onNext(item)
    }
    
}
