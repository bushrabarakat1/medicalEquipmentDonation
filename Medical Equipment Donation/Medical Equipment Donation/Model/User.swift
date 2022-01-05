//
//  User.swift
//  Medical Equipment Donation
//
//  Created by Bushra Barakat on 23/05/1443 AH.
//

import Foundation

struct User{
    var id = ""
    var imageUrl = ""
    var userName = ""
    var gender = ""
    var birthDay = ""
    var country = ""
    var email = ""
    var phoneNumber = ""
    var type = false
   
    
    init(dict:[String:Any]) {
        if let id = dict["id"] as? String,
           let imageUrl = dict["imageUrl"] as? String,
           let userName = dict["userName"] as? String,
           let gender = dict["gender"] as? String,
           let birthDay = dict["birthDay"] as? String,
           let country = dict["country"] as? String,
           let email = dict["email"] as? String,
           let phoneNumber = dict["phoneNumber"] as? String,
           let type = dict["type"] as? Bool{
            self.id = id 
            self.imageUrl = imageUrl
            self.userName = userName
            self.gender = gender
            self.birthDay = birthDay
            self.country = country
            self.email = email
            self.phoneNumber = phoneNumber
            self.type = type
            
        }
        
    }
}
