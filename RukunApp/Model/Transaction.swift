//
//  Transaction.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 19/06/22.
//

import Foundation

struct Transaction: Codable {
    let id: String?
    let date: Date
    var details: [TransactionDetail]
    
    init(id: String?, date: Date, details: [TransactionDetail]){
        self.id = id
        self.date = date
        self.details = details
    }
}

extension Transaction{
    var totalPrice: Double?{
        var total: Double = 0
        for detail in details {
            total += detail.totalPrice ?? 0
        }
        return total
    }
    
    var totalQty: Int{
        var total = 0
        for detail in details {
            total += detail.quantity
        }
        return total
    }
}
