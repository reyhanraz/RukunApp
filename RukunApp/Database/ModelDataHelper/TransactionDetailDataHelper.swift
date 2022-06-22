//
//  TransactionDetailDataHelper.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 19/06/22.
//

import Foundation
import SQLite

class TransactionDetailDataHelper: DataHelperProtocol {
    
    typealias T = TransactionDetail
    
    static let TABLE_NAME = "TransactionDetail"
       
    static let table = Table(TransactionDetailDataHelper.TABLE_NAME)
    static let transactionID = Expression<String>("transactionID")
    static let itemID = Expression<String>("itemID")
    static let itemQuantity = Expression<Int>("itemQuantity")

    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run( table.create(ifNotExists: true) {t in
                t.column(transactionID)
                t.column(itemID)
                t.column(itemQuantity)
                })
           
        } catch let error {
            print(error)
            // Error throw if table already exists
        }
    }
    
    static func insert(item: TransactionDetail) throws -> T {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let insert = table.insert(transactionID <- item.transactionID!, itemID <- item.itemID, itemQuantity <- item.quantity)
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
    
    static func update(item: TransactionDetail) throws -> T {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(transactionID == item.transactionID! && itemID == item.itemID)
        
        do {
            let tmp = try DB.run(query.update(itemQuantity <- item.quantity))
            guard tmp == 1 else {
                throw DataAccessError.Update_Error
            }
            return item

        } catch _ {
            throw DataAccessError.Update_Error
        }
    }
    
    static func delete(item: TransactionDetail) throws -> T {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(transactionID == item.transactionID!)
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
        let items = try DB.prepare(query)
        for item in  items {
            let _item = try ItemDataHelper.find(id: item[itemID])
            return TransactionDetail(transactionID: item[transactionID], itemID: item[itemID], quantity: item[itemQuantity], itemPrice: _item?.price)
        }
       
        return nil
       
    }
    
    static func findAll(id: String?) throws -> [T] {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [T]()
        let query = table.filter(transactionID == id!)
        let items = try DB.prepare(query)
        for item in items {
            let _item = try ItemDataHelper.find(id: item[itemID])
            retArray.append(TransactionDetail(transactionID: item[transactionID], itemID: item[itemID], quantity: item[itemQuantity], itemPrice: _item?.price))
        }
       
        return retArray
    }
}
