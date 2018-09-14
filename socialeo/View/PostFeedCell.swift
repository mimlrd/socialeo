//
//  PostFeedCell.swift
//  socialeo
//
//  Created by Mike Milord on 14/09/2018.
//  Copyright © 2018 First Republic. All rights reserved.
//

import UIKit

class PostFeedCell: UITableViewCell {
    
    @IBOutlet weak var postUserImageView: UIImageView!
    
    @IBOutlet weak var postUserFullNameLbl: UILabel!
    
    @IBOutlet weak var postDateLbl: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var postNbrLikeLbl: UILabel!
    
    @IBOutlet weak var postCaptionLbl: UILabel!
    
    @IBOutlet weak var postNbrCommentLbl: UILabel!
    
    var instaPost: InstaPost? {
        
        didSet{
            setupCell()
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    private func setupCell() {
        
        if let post = instaPost {
            let text = post.captionText
            let username = post.author.username
            let avatar_url = post.author.profilePictureUrl
            let postImage_url = post.standardImage["url"]
            let fullName = post.author.fullname
            let nbr_like = post.likeCount
            let nbr_comment = post.commentCount
            
            
            
            var likes = NSLocalizedString("like", comment: "like_singular")
            var comments = NSLocalizedString("comment", comment: "comment_singular")
            var viewComments = ""
            if nbr_like > 1 {
                likes = NSLocalizedString("likes", comment: "likes")
            }
            
            if nbr_comment > 1 {
                likes = NSLocalizedString("comments", comment: "comments")
            }
            
            if nbr_comment > 0 {
                viewComments = NSLocalizedString("View all", comment: "view_all_comment")
            }
            
            
            
            self.postCaptionLbl.text = text
            self.postCaptionLbl.text = "\(username): \(text)"
            self.postUserFullNameLbl.text = fullName
            self.postNbrLikeLbl.text = "\(nbr_like) \(likes)"
            self.postNbrCommentLbl.text = "\(viewComments) \(nbr_comment) \(comments)"
        }
    }
    
    
    
    
    
}
