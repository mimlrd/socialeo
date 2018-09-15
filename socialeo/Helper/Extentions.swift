//
//  Extentions.swift
//  socialeo
//
//  Created by Mike Milord on 14/09/2018.
//  Copyright © 2018 First Republic. All rights reserved.
//


/// An extension file to help with commonly used functionalities.

import UIKit

extension Date
{
    func toString (dateFormat format: String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    
    
    func getElapsedInterval() -> String {
        
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: Bundle.main.preferredLocalizations[0]) //--> IF THE USER HAVE THE PHONE IN SPANISH BUT THE APP ONLY SUPPORTS I.E. ENGLISH AND GERMAN WE SHOULD CHANGE THE LOCALE OF THE FORMATTER TO THE PREFERRED ONE (IS THE LOCALE THAT THE USER IS SEEING THE APP), IF NOT, THIS ELAPSED TIME IS GOING TO APPEAR IN SPANISH
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.calendar = calendar
        
        var dateString: String?
        
        let interval = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            formatter.allowedUnits = [.year] //2 years
        } else if let month = interval.month, month > 0 {
            formatter.allowedUnits = [.month] //1 month
        } else if let week = interval.weekOfYear, week > 0 {
            formatter.allowedUnits = [.weekOfMonth] //3 weeks
        } else if let day = interval.day, day > 0 {
            formatter.allowedUnits = [.day] // 6 days
        } else if let hour = interval.hour, hour > 0 {
            formatter.allowedUnits = [.hour]
        } else if let minute = interval.minute, minute > 0 {
            formatter.allowedUnits = [.minute]
        } else if let second = interval.second , second > 0 {
            formatter.allowedUnits = [.second]
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: Bundle.main.preferredLocalizations[0]) //--> IF THE USER HAVE THE PHONE IN SPANISH BUT YOUR APP ONLY SUPPORTS I.E. ENGLISH AND GERMAN WE SHOULD CHANGE THE LOCALE OF THE FORMATTER TO THE PREFERRED ONE (IS THE LOCALE THAT THE USER IS SEEING THE APP), IF NOT, THIS ELAPSED TIME IS GOING TO APPEAR IN SPANISH
            dateFormatter.dateStyle = .medium
            dateFormatter.doesRelativeDateFormatting = true
            
            dateString = dateFormatter.string(from: self) // IS GOING TO SHOW 'TODAY'
        }
        
        if dateString == nil, let date_str = formatter.string(from: self, to: Date()) {
            dateString = "\(date_str) \(NSLocalizedString("ago", comment: "ago"))"
        }
        
        return dateString!
    }
    
}


extension UIImageView {
    
    func roundingImageView(){
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true;
        
    }
    
}

extension String{
    
    func setCorrectForm(forNumnerOfElement nbrOfElement: Int, theSingularWord word:String) -> String {
        
        if nbrOfElement > 1 {
            return "\(word)s"
        }
        
        return word
    }
}
