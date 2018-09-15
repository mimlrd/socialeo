//
//  CommentCell.swift
//  socialeo
//
//  Created by Mike Milord on 15/09/2018.
//  Copyright © 2018 First Republic. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    @IBOutlet weak var usernameCommentLbl: UILabel!
    
    @IBOutlet weak var commentDateLbl: UILabel!
    
    @IBOutlet weak var containerWidthConstraint: NSLayoutConstraint!
    
    var comment: InstaComment? {
        didSet{
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initializeCell()

    }
    
    private func initializeCell(){
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let screenWidth = UIScreen.main.bounds.width
        containerWidthConstraint.constant = screenWidth - (2 * 12)
    }
    
    
    private func setupCell(){
        
        guard let my_comment = comment else {return}
        
        let username = my_comment.username
        let text = my_comment.text
        let timestamp = my_comment.timestamp
        let date = Date(timeIntervalSince1970: timestamp)
        
        
        let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)]
        let attributedString = NSMutableAttributedString(string:username, attributes:attrs)
        let normalString = NSMutableAttributedString(string:text)
        attributedString.append(normalString)
        
        self.usernameCommentLbl.attributedText = attributedString
        self.commentDateLbl.text = date.getElapsedInterval()
        
        
    }

}
