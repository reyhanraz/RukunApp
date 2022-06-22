//
//  Validation.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 19/06/22.
//

import Foundation

enum ValidationResult: Equatable{
    case ok(message: String?)
    case failed(message: String?)
    case empty
}

extension ValidationResult{
    var isValid: Bool{
        switch self {
        case .ok(_):
            return true
        default:
            return false
        }
    }
    
    var message: String?{
        switch self {
        case .ok(let message):
            return message
        case .failed(let message):
            return message
        case .empty:
            return nil
        }
    }
}
