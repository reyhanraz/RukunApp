//
//  ItemDataHelper.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 18/06/22.
//

import Foundation
import SQLite

class ItemDataHelper: DataHelperProtocol {
    
    typealias T = Item
    
    static let TABLE_NAME = "Items"
       
    static let table = Table(ItemDataHelper.TABLE_NAME)
    static let itemId = Expression<String>("itemid")
    static let itemName = Expression<String>("itemName")
    static let itemPrice = Expression<Double>("itemPrice")
    static let itemQuantity = Expression<Int>("itemQuantity")

    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run( table.create(ifNotExists: true) {t in
                t.column(itemId, primaryKey: true)
                t.column(itemName)
                t.column(itemPrice)
                t.column(itemQuantity)
                })
           
        } catch let error {
            print(error)
            // Error throw if table already exists
        }
    }
    
    static func insert(item: Item) throws -> Item {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let insert = table.insert(itemId <- UUID().uuidString, itemName <- item.name, itemPrice <- item.price, itemQuantity <- item.quantity)
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
    
    static func update(item: Item) throws -> Item {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(itemId == item.id!)
        
        do {
            let tmp = try DB.run(query.update(itemName <- item.name, itemPrice <- item.price, itemQuantity <- item.quantity))
            guard tmp == 1 else {
                throw DataAccessError.Update_Error
            }
            return item
        } catch _ {
            throw DataAccessError.Update_Error
        }
    }
    
    static func updateQty(id: String, quantity: Int) throws -> Int {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(itemId == id)
        
        do {
            let tmp = try DB.run(query.update(itemQuantity <- itemQuantity - quantity))
            guard tmp == 1 else {
                throw DataAccessError.Update_Error
            }
            return tmp
        } catch _ {
            throw DataAccessError.Update_Error
        }
    }
    
    static func delete(item: Item) throws -> Item {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(itemId == item.id!)
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
        let query = table.filter(itemId == id)
        let items = try DB.prepare(query)
        for item in  items {
            return Item(id: item[itemId], name: item[itemName], price: item[itemPrice], quantity: item[itemQuantity])
        }
       
        return nil
       
    }
    
    static func findAll(id: String?) throws -> [Item] {
        guard let DB = SQLiteDataStore.sharedInstance.BBDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [T]()
        let items = try DB.prepare(table)
        for item in items {
            retArray.append(Item(id: item[itemId], name: item[itemName], price: item[itemPrice], quantity: item[itemQuantity]))
        }
       
        return retArray
    }
}
