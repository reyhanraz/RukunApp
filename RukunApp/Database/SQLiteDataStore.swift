//
//  SQLiteDataStore.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 18/06/22.
//

import Foundation
import SQLite

class SQLiteDataStore {
    static let sharedInstance = SQLiteDataStore()
    let BBDB: Connection?
   
    private init() {
        let dirs: [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)

        let dir = dirs[0]
        let path = dir + "BaseballDB.sqlite"
        
       
        do {
            BBDB = try Connection(path)
        } catch _ {
            BBDB = nil
        }
    }
   
    func createTables() throws{
        do {
            try ItemDataHelper.createTable()
            try TransactionDataHelper.createTable()
            try TransactionDetailDataHelper.createTable()
        } catch {
            throw DataAccessError.Datastore_Connection_Error
        }
    }
}
