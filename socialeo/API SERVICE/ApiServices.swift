//
//  ApiServices.swift
//  socialeo
//
//  Created by Mike Milord on 14/09/2018.
//  Copyright © 2018 First Republic. All rights reserved.
//


/// This clas is where all the related connections with the sever will be done
/// This will make much easier to maintain and to find when something goes wrong.

import Foundation

class ApiServices: NSObject {
    
    weak var downloadDelegate: FinishDownloadDelegate?
    
    public func fetchInstagramPosts() {
        
        let baseUrlStr = "\(INSTABASE_IDS.AUTHURL)\(INSTABASE_IDS.ACCESSTOKEN)"
        
        guard let url = URL(string: baseUrlStr) else {return}
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let err = error {
                // check to see if there is an error while downloading data
                print(err.localizedDescription)
                return
            }
            
            // No error so we can continue and parse our json
            do {
                if let results = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:Any] {
                    
                    for (key, value) in results {
                        // only get the value for the key data, as this is where data that interest us are
                        if key == "data" {
                            guard let valArray = value as? [Any] else {return}
                            self.setupTheValue(valArray)
                        }
                    }
                }
                
                
            } catch {
                // TODO: Here we can present an alert view letting the user know that something when wrong
                print("Error -> \(error.localizedDescription)")
            }
            
        }
        
        task.resume()
        
    }
    
    private func setupTheValue(_ vals: [Any]) {
        
        var posts: [InstaPost] = [InstaPost]()
        //Convenient variables
        var nbrOfLikes: Int = 0
        var nbrOfComments: Int = 0
        
        for val in vals {
            
            // assign the correct values to the convenients variables so it will be easier to maintain.
            // the guard - continue will prevent that if a post has a missing info, the other post will still be downloaded and ommit the problematic post.
            
            guard let dict = val as? [String: Any],
                let images = dict["images"] as? [String : Any],
                let user = dict["user"] as? [String : Any],
                let timestamp = dict["created_time"] as? String,
                let postId = dict["id"] as? String,
                let likes = dict["likes"] as? [String : Int],
                let comments = dict["comments"] as? [String : Int] else {continue}
            
            let caption = dict["caption"] as? [String : Any] ?? ["text":""]
            
            
            if let fullName = user["full_name"] as? String,
                let profilePictureUrl = user["profile_picture"] as? String,
                let uid = user["id"] as? String,
                let username = user["username"] as? String,
                let text = caption["text"] as? String,
                let standardImage =  images["standard_resolution"] as? [String: Any],
                let thumbnail = images["thumbnail"] as? [String: Any],
                let likeCount = likes["count"],
                let commentCount = comments["count"]
            {
                
                
                let instaUser = InstaUser(id: uid, fullname: fullName, profilePictureUrl: profilePictureUrl, username: username)
                
                let post = InstaPost(id: postId, timestamp: Double(timestamp)!, captionText: text, likeCount: likeCount, commentCount: commentCount, thumbnailImage: thumbnail, standardImage: standardImage, author: instaUser)
                
                posts.append(post)
                
                // add the number of likes and comments in each post for the stata
                nbrOfLikes += likeCount
                nbrOfComments += commentCount
                
                
            }// end of if
            
            
        } // end of for loop
        
        // Now create a dictionary object to save in the user default so other view could accesss
        let socialDictionary: [String:Int] = ["nbrOfPosts": posts.count, "nbrOfLikes": nbrOfLikes, "nbrOfComments": nbrOfComments]
        // Save to the userdefault
        UserDefaults.standard.set(socialDictionary, forKey: "socialStats")
        
        // Update the delegate so the observing view will know that the download is done
        if let del = downloadDelegate {
           
            
            del.finishToDownloadPosts(posts)
        }
        
        
    }
    
    
    
    public func fetchCommentForPost(_ postId: String) {
        
        let baseUrlStr = "\(INSTABASE_IDS.COMMENTURL_PART1)\(postId)\(INSTABASE_IDS.COMMENTURL_PART2)\(INSTABASE_IDS.ACCESSTOKEN)"
        
        guard let url = URL(string: baseUrlStr) else {return}
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let err = error {
                // check to see if there is an error while downloading data
                print(err.localizedDescription)
                return
            }
            
            // No error so we can continue and parse our json
            do {
                if let results = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:Any] {
                    
                    for (key, value) in results {
                        // only get the value for the key "data", as this is where data that interest us are
                        
                        if key == "data" {
                            guard let valArray = value as? [Any] else {return}
                           self.setupTheCommentValues(valArray) // We call another function to make the code cleaner and easier to understand
                        }

                    }
                }
                
                
            } catch {
                // TODO: Here we can present an alert view letting the user know that something when wrong
                print("Error -> \(error.localizedDescription)")
            }
            
        }
        
        task.resume()
        
    }
    
    
    
    private func setupTheCommentValues(_ vals: [Any]) {

        var comments: [InstaComment] = [InstaComment]()
        
        for val in vals {
        
            guard let dict = val as? [String: Any]
                 else {continue}
            
            if let from = dict["from"] as? [String: String],
                let username = from["username"],
                let id = dict["id"] as? String,
                let timestamp = dict["created_time"] as? String,
                let text = dict["text"] as? String {

                let comment = InstaComment(id: id, timestamp: Double(timestamp)!, username: username, text: text)
                comments.append(comment)
            }
            
            
        } // end of for loop
        
        
        // Update the delegate so the observing view will know that the download is done
        if let del = downloadDelegate {
            
            
            del.finishToDownloadPosts(comments)
        }
        
        
    }
    
}

