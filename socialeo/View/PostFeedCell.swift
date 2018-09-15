//
//  PostFeedCell.swift
//  socialeo
//
//  Created by Mike Milord on 14/09/2018.
//  Copyright © 2018 First Republic. All rights reserved.
//

import UIKit
import SDWebImage

class PostFeedCell: UITableViewCell {
    
    @IBOutlet weak var postUserImageView: UIImageView!
    
    @IBOutlet weak var postUserFullNameLbl: UILabel!
    
    @IBOutlet weak var postDateLbl: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var postNbrLikeLbl: UILabel!
    
    @IBOutlet weak var postCaptionLbl: UILabel!
    
    @IBOutlet weak var postNbrCommentLbl: UILabel!
    
    var homeVC: HomeVC?
    
    var postId: String?
    
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
            let postImage_url = post.standardImage["url"] as! String
            let fullName = post.author.fullname
            let nbr_like = post.likeCount
            let nbr_comment = post.commentCount
            let timestamp = post.timestamp
            let date = Date(timeIntervalSince1970: timestamp)
            
            postId = post.id // to pass to homeVC so we can download the comments
            
            self.postUserImageView.roundingImageView()
            
            // Will download the different images for the cell using SDWebImage for caching and asynchronous download
            downloadPostAuthorInfo(forImageView: postUserImageView, withImageUrl: avatar_url)
            downloadPostAuthorInfo(forImageView: postImageView, withImageUrl: postImage_url)
            
            let likeStr = NSLocalizedString("like", comment: "like_singular")
            let commentStr = NSLocalizedString("comment", comment: "comment_singular")
            var viewComments = ""
            if nbr_comment > 0 {
                viewComments = NSLocalizedString("View all", comment: "view_all_comment")
            }
            
            
            
            self.postCaptionLbl.text = text
            self.postCaptionLbl.text = "\(username): \(text)"
            self.postUserFullNameLbl.text = fullName.lowercased()
            self.postNbrLikeLbl.text = "\(nbr_like) \(likeStr.setCorrectForm(forNumnerOfElement: nbr_like, theSingularWord: likeStr))"
            self.postNbrCommentLbl.text = "\(viewComments) \(nbr_comment) \(commentStr.setCorrectForm(forNumnerOfElement: nbr_comment, theSingularWord: commentStr))"
            self.postDateLbl.text = date.getElapsedInterval()
        }
        
        addGestureReconizerToViews()
    }
    
    
    
    fileprivate func downloadPostAuthorInfo(forImageView imageView: UIImageView, withImageUrl  urlStr: String){
        let url = URL(string: urlStr)
        
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
        }
    
    
    fileprivate func addGestureReconizerToViews(){
        
        // First the views need to accept interaction with the user
        self.postImageView.isUserInteractionEnabled = true
        self.postNbrCommentLbl.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tapGesture.numberOfTapsRequired = 1
        self.postNbrCommentLbl.addGestureRecognizer(tapGesture)
        
        let tabImageGesture = UITapGestureRecognizer(target: self, action: #selector(handleZoomTap(_:)))
        tabImageGesture.numberOfTapsRequired = 1
        self.postImageView.addGestureRecognizer(tabImageGesture)
    }
    
    @objc private func handleTapGesture() {
        
        /// Let the HomeVC know that the user has tapped the label and want to segue to CommentVC
        if let homeViewController = homeVC, let selectedPostId = postId{
            
            homeViewController.pushView(withPostId: selectedPostId)
        }
        
    
    }
    
    @objc private func handleZoomTap(_ tapGesture: UITapGestureRecognizer) {
        guard let imageView = tapGesture.view as? UIImageView  else {return }
        
        if let homeViewController = homeVC {
            
            homeViewController.performZoomInForStartingImageView(imageView)
        }
    }
    
    

    
    
    
}
