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
            setupCell()

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Calling the function allow dynamic resizing of the cell
        initializeCell()
    }
    
    private func initializeCell(){
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.width
        containerWidthConstraint.constant = screenWidth - (2 * 12)
    }
    
    
    private func setupCell(){
        
        guard let my_comment = comment else {return}
        
        // Convenient variables
        let username = my_comment.username
        let text = my_comment.text
        let timestamp = my_comment.timestamp
        let date = Date(timeIntervalSince1970: timestamp)
        
        self.usernameCommentLbl.attributedText = "".twoPartAttributeString(forFirstPartText: username, theOtherPart: text, withFontName: "AvenirNext-Medium", andFontSize: 15)
        self.commentDateLbl.text = date.getElapsedInterval()
        
        
    }

}
