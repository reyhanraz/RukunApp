//
//  Preference.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 19/06/22.
//

import Foundation

struct Preference{
    private let _defaults = UserDefaults()
    
    enum Key: String{
        case id
        case name
        case email
    }
    
    func getUser() -> User{
        let id = _defaults.string(forKey: Key.id.rawValue)
        let name = _defaults.string(forKey: Key.name.rawValue)
        let email = _defaults.string(forKey: Key.email.rawValue)

        return User(id: id, name: name, email: email)
    }
    
    func save(user: User){
        _defaults.set(user.id, forKey: Key.id.rawValue)
        _defaults.set(user.name, forKey: Key.name.rawValue)
        _defaults.set(user.email, forKey: Key.email.rawValue)
    }
    
    func clearDefault(){
        _defaults.removeObject(forKey: Key.id.rawValue)
        _defaults.removeObject(forKey: Key.name.rawValue)
        _defaults.removeObject(forKey: Key.email.rawValue)
    }
    
}
