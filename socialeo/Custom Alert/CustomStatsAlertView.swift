//
//  CustomStatsAlertView.swift
//  socialeo
//
//  Created by Mike Milord on 14/09/2018.
//  Copyright © 2018 First Republic. All rights reserved.
//

import UIKit

class CustomStatsAlertView: UIView {
    
    @IBOutlet var customStatsAlertView: UIView!
    
    @IBOutlet weak var nbrOfPostsLbl: UILabel!
    
    @IBOutlet weak var nbrOfLikesLbl: UILabel!
    
    @IBOutlet weak var nbrOfCommentsLbl: UILabel!
    
    weak var delegate: AlertActionButtonDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("CustomStatsAlertView", owner: self, options: nil)
        addSubview(customStatsAlertView)
        customStatsAlertView.frame = self.bounds
        customStatsAlertView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        
    }
    
    
    
    
    
    @IBAction func DidTapActionButton(_ sender: UIButton) {
        
        if let del = delegate {
            // Let the view which conform to the delegate know about the action
            del.didTapDoneActionButton()
        }
    }
    
    
    
}
