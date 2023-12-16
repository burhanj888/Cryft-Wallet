//
//  User.swift
//  Cryft Wallt
//
//  Created by Burhanuddin Jinwala on 12/12/23.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname){
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
}


extension User {
    static var Mock_User: User {
        // Create an instance of Wallet with an initial balance, if required.
        // For example, initializing with a balance of 0:
        
        // Now, use this instance to create the mock User
        return User(id: NSUUID().uuidString, fullname: "Kobe Bryant", email: "test@gmail.com")
    }
}
