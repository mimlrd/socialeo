//
//  CustomStatsAlert.swift
//  socialeo
//
//  Created by Mike Milord on 14/09/2018.
//  Copyright © 2018 First Republic. All rights reserved.
//

import UIKit

class CustomStatsAlert: UIView, CommonModal, AlertActionButtonDelegate {
    
    var statsAlertView: CustomStatsAlertView = CustomStatsAlertView ()
    let backgroundView: UIView = UIView()
    private let alertLeadingSpace: CGFloat = 32
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init (title:String, message: String) {
        self.init(frame: UIScreen.main.bounds)
        
        initialize(forAlertTitle: title, withMessage: message)
        
        
    }
    
    
    func initialize(forAlertTitle title:String, withMessage message: String){
        
        self.commonAlertView.clipsToBounds = true
        self.commonAlertView.delegate = self
        
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.8
        
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        addSubview(backgroundView)
        
        setupAlertView(forAlertTitle: title, withMessage: message)
    }
    
    
    fileprivate func setupAlertView(forAlertTitle title:String, withMessage message: String) {
        
        /* -------- Setup the dialogue view ----------- */
        let alertViewWidth = frame.width - (alertLeadingSpace * 2)
        let alertViewHeight = frame.height * 0.4
        self.statsAlertView.frame.origin = CGPoint(x: alertLeadingSpace, y: frame.height)
        self.statsAlertView.frame.size = CGSize(width: alertViewWidth, height: alertViewHeight)
        self.statsAlertView.backgroundColor = UIColor.white
        self.statsAlertView.layer.cornerRadius = 6
        self.addSubview(statsAlertView)
        
        
        //Setup title and message
        
        
    }
    
    func didTapDoneActionButton(){
        dismiss(animated: true)
    }
    
    
    @objc private func didTappedOnBackgroundView(){
        // dismiss the alert here
        dismiss(animated: true)
    }
    
    
    
}

