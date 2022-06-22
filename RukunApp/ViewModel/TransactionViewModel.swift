//
//  TransactionViewModel.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 20/06/22.
//

import Foundation
import RxSwift
import RxCocoa


struct TransactionViewModel{
    typealias T = Transaction
    let result: Driver<[T]>
    let insertResult: Driver<T>
    let updateResult: Driver<T>
    let deletedItem: Driver<T>
    
    private let _getList = PublishSubject<Void>()
    private let _update = PublishSubject<T>()
    private let _delete = PublishSubject<T>()
    private let _insert = PublishSubject<T>()


        
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
        
        insertResult = _insert.asDriver(onErrorDriveWith: .empty())
            .flatMapLatest({ request -> Driver<Result<T, DataAccessError>> in
                service.insert(request: request).asDriver(onErrorDriveWith: .empty())
            }).flatMapLatest({ result in
                switch result{
                    
                case .success(let item):
                    return .just(item)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                return .empty()
            })
        
        updateResult = _update.asDriver(onErrorDriveWith: .empty())
            .flatMapLatest({ request -> Driver<Result<T, DataAccessError>> in
                service.update(request: request).asDriver(onErrorDriveWith: .empty())
            }).flatMapLatest({ result in
                switch result{
                    
                case .success(let item):
                    return .just(item)
                case .failure(let error):
                    print(error.localizedDescription)
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
                case .failure(let error):
                    print(error.localizedDescription)
                }
                return .empty()
            })
        
        
    }
    
    func getAll(){
        _getList.onNext(())
    }
    
    func update(item: T){
        _update.onNext(item)
    }
    
    func insert(item: T){
        _insert.onNext(item)
    }
    
    func delete(item: T){
        _delete.onNext(item)
    }
    
}
