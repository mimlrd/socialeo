//
//  BaseView.swift
//  socialeo
//
//  Created by Mike Milord on 15/09/2018.
//  Copyright © 2018 First Republic. All rights reserved.
//


/// A BaseView template to follow when adding a custom view

import UIKit

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        /// Add here the registration of the Nib file for the Bundle
        /// addSubview(customview)
        /// customview.frame = self.bounds
        /// Make customview.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }
    

}
