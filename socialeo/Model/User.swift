//
//  User.swift
//  socialeo
//
//  Created by Mike Milord on 14/09/2018.
//  Copyright © 2018 First Republic. All rights reserved.
//

import Foundation


struct InstaUser {
    
    var id: String
    var fullname: String
    var profilePictureUrl: String
    var username: String
    
    init(id: String, fullname: String, profilePictureUrl: String, username: String){
        
        self.id = id
        self.fullname = fullname
        self.profilePictureUrl = profilePictureUrl
        self.username = username
    }
}
