//
//  Post.swift
//  Medical Equipment Donation
//
//  Created by Bushra Barakat on 23/05/1443 AH.
//

import Foundation
import Firebase

struct Post {
    var id = ""
    var userId = ""
    var imageUrl = ""
    var title = ""
    var description = ""
    var user : User
    var createdAt:Timestamp?
    
    init(dict:[String:Any], id:String,user:User) {
        if let userId = dict["userId"] as? String,
           let imageUrl = dict["imageUrl"] as? String,
           let title = dict["title"] as? String,
           let description = dict["description"] as? String,
           let createdAt = dict["createdAt"] as? Timestamp{
            self.userId = userId
            self.imageUrl = imageUrl
            self.title = title
            self.description = description
            self.createdAt = createdAt
        }
        self.id = id
        self.user = user
            
    }
}
