//
//  DataHelperProtocol.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 18/06/22.
//

protocol DataHelperProtocol {
    associatedtype T
    static func createTable() throws -> Void
    static func insert(item: T) throws -> T
    static func update(item: T) throws -> T
    static func delete(item: T) throws -> T
    static func findAll(id: String?) throws -> [T]
}
