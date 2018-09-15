//
//  InputTextView.swift
//  socialeo
//
//  Created by Mike Milord on 15/09/2018.
//  Copyright © 2018 First Republic. All rights reserved.
//

/// A class extension where new functionalitie such as placeholder, remove placeholder
/// for the textView class. This class mimic the placeholder of the textField.

import UIKit

class InputTextView: UITextView {
    
    private var originalTextColour: UIColor = UIColor.black
    private var placeholderTextColour: UIColor = UIColor(red: 0, green: 0, blue: 0.098, alpha: 0.22)
    
    var placeholder:String?{
        didSet{
            if let placeholder = placeholder{
                text = placeholder
            }
        }
    }
    
    override internal var text: String? {
        didSet{
            textColor = originalTextColour
            if text == placeholder{
                textColor = placeholderTextColour
            }
        }
    }
    
    override internal var textColor: UIColor?{
        didSet{
            if let textColor = textColor, textColor != placeholderTextColour{
                originalTextColour = textColor
                if text == placeholder{
                    self.textColor = placeholderTextColour
                }
            }
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        // Remove the padding top and left of the text view
        self.textContainer.lineFragmentPadding = 0
        self.textContainerInset = UIEdgeInsets.zero
        self.translatesAutoresizingMaskIntoConstraints = false

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    func removePlaceholder(){
        if text == placeholder{
            text = ""
        }
    }
    
    func addPlaceholder(){
        if text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            text = placeholder
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
