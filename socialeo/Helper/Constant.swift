//
//  Constant.swift
//  socialeo
//
//  Created by Mike Milord on 14/09/2018.
//  Copyright © 2018 First Republic. All rights reserved.


///  This file will keep all the constant of the app so
///  as we use the differnt constants in differnt places,
///  in case of any changes in a string we will only have one
///  place to make the change and it will propagate to the rest
///  of the app.

import UIKit

struct INSTABASE_IDS {
    
    static let AUTHURL = "https://api.instagram.com/v1/users/self/media/recent/?access_token="
    static let ACCESSTOKEN = "5702866500.e4414e3.5eae945c2d364d70b06c1212d8a09362"
    static let USER_ID = "5702866500"
    static let COMMENTURL_PART1 = "https://api.instagram.com/v1/media/"
    static let COMMENTURL_PART2 = "/comments?access_token="
}


struct IDENTIFIERS {
    
    static let feedCellIdentifier = "feedCell"
    static let nibFeedCell = "PostFeedCell"
    static let seguehomeVCToCommentVC = "pushSegueToCommentVC"
    static let commentCellIdentifier = "feedCommentCell"
    static let nibCommentCell = "CommentCell"
    static let marginTextViewHeight: CGFloat = 16

}
