//
//  Item.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 18/06/22.
//

import Foundation

struct Item: Codable {
    let id: String?
    var name: String
    var price: Double
    var quantity: Int
}
