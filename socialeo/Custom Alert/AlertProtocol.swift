//
//  AlertProtocol.swift
//  socialeo
//
//  Created by Mike Milord on 14/09/2018.
//  Copyright © 2018 First Republic. All rights reserved.
//

import Foundation
import UIKit

protocol AlertActionButtonDelegate: class {
    
    func didTapDoneActionButton()
}

protocol Modal {
    
    /// Protocol set the blue print of the functions for the modal
    func show(animated:Bool)
    func dismiss(animated:Bool)
    var backgroundView:UIView {get}
    var statsAlertView: CustomStatsAlertView {get set}
}


