//
//  Post.swift
//  socialeo
//
//  Created by Mike Milord on 14/09/2018.
//  Copyright © 2018 First Republic. All rights reserved.
//

import UIKit


struct InstaPost {
    var id: String
    var timestamp: TimeInterval
    var captionText: String
    var likeCount: Int
    var commentCount: Int
    var thumbnailImage: [String: Any]
    var standardImage: [String: Any]
    var author: InstaUser
    
    init(id: String, timestamp: TimeInterval, captionText: String, likeCount: Int, commentCount: Int, thumbnailImage: [String: Any], standardImage: [String: Any], author: InstaUser)
        
    {
        self.id = id
        self.timestamp = timestamp
        self.captionText = captionText
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.thumbnailImage = thumbnailImage
        self.standardImage = standardImage
        self.author = author
        
    }
    
    
    
}


struct InstaComment {
    
    var id: String
    var timestamp: TimeInterval
    var username: String
    var text: String
    
    init(id: String, timestamp: TimeInterval, username: String, text: String) {
        
        self.id = id
        self.timestamp = timestamp
        self.username = username
        self.text = text
    }
}



