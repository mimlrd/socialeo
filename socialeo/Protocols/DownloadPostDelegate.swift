//
//  DownloadPostDelegate.swift
//  socialeo
//
//  Created by Mike Milord on 14/09/2018.
//  Copyright © 2018 First Republic. All rights reserved.
//

import Foundation


protocol FinishDownloadDelegate: class {
    /// protocol to let the observer views know that the post have been downloaded
    func finishToDownloadPosts<T>(_ elements:[T])
}
