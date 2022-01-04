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
    var imageUrl = ""
    var title = ""
    var description = ""
    var user : User
    var createdAt:Timestamp?
  
    init(dict:[String:Any], id:String,user:User) {
         if  let imageUrl = dict["imageUrl"] as? String,
           let title = dict["title"] as? String,
           let description = dict["description"] as? String,
           let createdAt = dict["createdAt"] as? Timestamp{
            self.imageUrl = imageUrl
            self.title = title
            self.description = description
            self.createdAt = createdAt
           
        }
        self.id = id
        self.user = user
            
    }
}
