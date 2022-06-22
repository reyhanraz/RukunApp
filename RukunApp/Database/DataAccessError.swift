//
//  DataAccessError.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 18/06/22.
//

import Foundation
enum DataAccessError: Error {
    case Datastore_Connection_Error
    case Insert_Error
    case Update_Error
    case Delete_Error
    case Search_Error
    case Nil_In_Data
    case InvalidRequest
}
