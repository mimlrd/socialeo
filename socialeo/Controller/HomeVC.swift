//
//  HomeVC.swift
//  socialeo
//
//  Created by Mike Milord on 14/09/2018.
//  Copyright © 2018 First Republic. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var instaFeedTable: UITableView!
    
    // Constants for setup
    let cellId = IDENTIFIERS.feedCellIdentifier
    let nibCellName = IDENTIFIERS.nibFeedCell
    
    // Variables
    var currentUser: InstaUser?
    var posts: [InstaPost] = [InstaPost]() // It might not have any post available
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        
        // Download the posts from Instagram servers
        let apiServices = ApiServices()
        apiServices.downloadDelegate = self
        apiServices.fetchInstagramPosts()
    }
    
    fileprivate func setupTable() {
        
        instaFeedTable.dataSource = self
        instaFeedTable.delegate = self
        
        // Let register the cell for the table
        let nibCell = UINib(nibName: nibCellName , bundle: nil)
        instaFeedTable.register(nibCell, forCellReuseIdentifier: cellId)
        
    }
    
    
    
}

extension HomeVC: FinishDownloadDelegate {
    
    func finishToDownloadPosts<T>(_ elements: [T]) {
        
        if let my_posts = elements as? [InstaPost] {
            
            self.posts.removeAll()
            
            self.posts = my_posts.sorted(by: { (post1, post2) -> Bool in
                post1.timestamp > post2.timestamp
            })
            
            DispatchQueue.main.async {
                self.instaFeedTable.reloadData()
            }
            
        }
    }
    

}

extension HomeVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Check to see if posts is not nil and there is a uitableviewcell to dequeue
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? PostFeedCell else {return UITableViewCell()}
        
        
        cell.instaPost = posts[indexPath.row]
        
        return cell
    }
    
    
    
}

extension HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // We will need to setup the height of the row according to the image size which can vary
        
        // guard let my_posts = posts else {return 0.0} // avoid the app to crash if the post is nil, falling with grace
        let post = posts[indexPath.row]
        
        if let imageOiginalWidth = post.standardImage["width"] as? CGFloat,
            let imageOriginalHeight = post.standardImage["height"] as? CGFloat {
            
            let viewWidth = view.frame.width
            let newImage_height = (imageOriginalHeight / imageOiginalWidth) * viewWidth
            
            // Need the header, vertical spaces between views and bottom heights
            let topViewHeaderHeight : CGFloat = 55
            let bottomViewHeight: CGFloat = 42 + 25 + 8
            let imageBottomViewSpace: CGFloat = 10
            let bottomVerticalSpace: CGFloat = 10
            let sum_otherVerticalSpace: CGFloat = topViewHeaderHeight + bottomViewHeight + imageBottomViewSpace + bottomVerticalSpace
            
            return CGFloat(newImage_height + sum_otherVerticalSpace)
            
        }
        
        
        return 0.0
    }
}


