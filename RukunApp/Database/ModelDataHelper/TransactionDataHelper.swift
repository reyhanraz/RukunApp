//
//  TransactionDataHelper.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 19/06/22.
//

import Foundation
import SQLite

class TransactionDataHelper: DataHelperProtocol {
    
    typealias T = Transaction
    
    static let TABLE_NAME = "Transaction"
       
    static let table = Table(TransactionDataHelper.TABLE_NAME)
    static let transactionID = Expression<String>("transactionID")
    static let date = Expression<String>("date")

    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run( table.create(ifNotExists: true) {t in
                t.column(transactionID)
                t.column(date)
                })
           
        } catch let error {
            print(error)
            // Error throw if table already exists
        }
    }
    
    static func insert(item: Transaction) throws -> Transaction {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let insert = table.insert(transactionID <- item.id!, date <- item.date.toUTCString)
        do {
            let rowId = try DB.run(insert)
            guard rowId > 0 else {
                throw DataAccessError.Insert_Error
            }
            
            return item
        } catch _ {
            throw DataAccessError.Insert_Error
        }
    }
    
    static func update(item: Transaction) throws -> Transaction {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(transactionID == item.id!)
        
        do {
            let tmp = try DB.run(query.update(date <- item.date.toUTCString))
            guard tmp == 1 else {
                throw DataAccessError.Update_Error
            }
            return item

        } catch _ {
            throw DataAccessError.Update_Error
        }
    }
    
    static func delete(item: Transaction) throws -> Transaction {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(transactionID == item.id!)
        do {
            let tmp = try DB.run(query.delete())
            guard tmp == 1 else {
                throw DataAccessError.Delete_Error
            }
            return item

        } catch _ {
            throw DataAccessError.Delete_Error
        }
    }
    
    static func find(id: String) throws -> T? {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(transactionID == id)
        let rows = try DB.prepare(query)
        for row in  rows {
            let query = try TransactionDetailDataHelper.findAll(id: row[transactionID])
            return Transaction(id: row[transactionID], date: row[date].UTCStringToDate()!, details: query)
        }
       
        return nil
       
    }
    
    static func findAll(id: String?) throws -> [T] {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [T]()
        let query = table.order(transactionID.desc)
        let rows = try DB.prepare(query)
        for row in rows {
            let query = try TransactionDetailDataHelper.findAll(id: row[transactionID])
            retArray.append(Transaction(id: row[transactionID], date: row[date].UTCStringToDate()!, details: query))
        }
       
        return retArray
    }
}
