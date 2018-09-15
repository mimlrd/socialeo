//
//  CustomStatsAlert.swift
//  socialeo
//
//  Created by Mike Milord on 14/09/2018.
//  Copyright © 2018 First Republic. All rights reserved.
//

import UIKit

class CustomStatsAlert: UIView, Modal, AlertActionButtonDelegate {
    
    
    var statsAlertView: CustomStatsAlertView = CustomStatsAlertView ()
    let backgroundView: UIView = UIView()
    private let alertLeadingSpace: CGFloat = 32
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init (forSocialStats socialStats: SocialStat) {
        self.init(frame: UIScreen.main.bounds)
        
        initialize(forSocialStats: socialStats)
        
        
    }
    
    
    func initialize(forSocialStats socialStats: SocialStat){
        
        self.statsAlertView.clipsToBounds = true
        self.statsAlertView.delegate = self
        
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.8
        
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        addSubview(backgroundView)
        
        setupAlertView(withStatistics: socialStats)
    }
    
    
    fileprivate func setupAlertView(withStatistics stats: SocialStat) {
        
        /* -------- Setup the dialogue view ----------- */
        let alertViewWidth = frame.width - (alertLeadingSpace * 2)
        let alertViewHeight = frame.height * 0.35
        self.statsAlertView.frame.origin = CGPoint(x: alertLeadingSpace, y: frame.height)
        self.statsAlertView.frame.size = CGSize(width: alertViewWidth, height: alertViewHeight)
        self.statsAlertView.backgroundColor = UIColor.white
        self.statsAlertView.layer.cornerRadius = 6
        self.addSubview(statsAlertView)
        
        
        //Setup title and message
        let nbrOfPost = stats.nbrOfPost
        let nbrOfLike = stats.nbrOfLike
        let nbrOfComment = stats.nbrOfComment
        
        let postStr = NSLocalizedString("post", comment: "post_singular")
        let likeStr = NSLocalizedString("like", comment: "like_singular")
        let commentStr = NSLocalizedString("comment", comment: "comment_singular")
        
        self.statsAlertView.nbrOfPostsLbl.text = "\(nbrOfPost) \(postStr.setCorrectForm(forNumnerOfElement: nbrOfPost, theSingularWord: postStr))"
        self.statsAlertView.nbrOfLikesLbl.text = "\(nbrOfLike) \(likeStr.setCorrectForm(forNumnerOfElement: nbrOfLike, theSingularWord: likeStr))"
        self.statsAlertView.nbrOfCommentsLbl.text = "\(nbrOfComment) \(commentStr.setCorrectForm(forNumnerOfElement: nbrOfComment, theSingularWord: commentStr))"
        
    }
    
    func didTapDoneActionButton(){
        dismiss(animated: true)
    }
    
    
    @objc private func didTappedOnBackgroundView(){
        // dismiss the alert here
        dismiss(animated: true)
    }
    
    
    
}

