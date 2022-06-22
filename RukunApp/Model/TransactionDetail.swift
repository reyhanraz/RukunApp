//
//  TransactionDetail.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 19/06/22.
//

import Foundation

struct TransactionDetail: Codable{
    let transactionID: String?
    let itemID: String
    var quantity: Int
    var itemPrice: Double?
}

extension TransactionDetail{
    var totalPrice: Double?{
        
        return (itemPrice ?? 0) * Double(quantity)
    }
}
