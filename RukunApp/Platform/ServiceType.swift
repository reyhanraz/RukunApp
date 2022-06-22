//
//  ServiceType.swift
//  MoviesApp
//
//  Created by Reyhan Rifqi Azzami on 15/06/22.
//

import Foundation
import RxSwift

protocol ServiceType{
    associatedtype T
    associatedtype R

    func insert(request: R?) -> Observable<Result<T, DataAccessError>>
    func update(request: R?) -> Observable<Result<T, DataAccessError>>
    func delete(request: R?) -> Observable<Result<T, DataAccessError>>
    func get(request: String?) -> Observable<Result<T, DataAccessError>>
    func getAll(request: R?) -> Observable<Result<[T], DataAccessError>>

}
