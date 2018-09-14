//
//  ApiServices.swift
//  socialeo
//
//  Created by Mike Milord on 14/09/2018.
//  Copyright © 2018 First Republic. All rights reserved.
//

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
                            //let dict = value as? [String: Any]
                            
                            guard let valArray = value as? [Any] else {return}
                            // print("+++++++++ value: \(valArray) +++++++")
                            self.setupTheValue(valArray)
                            
                            
                            
                        }
                        
                        
                        
                    }
                }
                
                
            } catch {
                print("Error -> \(error.localizedDescription)")
            }
            
        }
        
        task.resume()
        
    }
    
    private func setupTheValue(_ vals: [Any]) {
        
        //var instaUser: InstaUser?
        var posts: [InstaPost] = [InstaPost]()
        
        for val in vals {
            
            //print("val: \(val)")
            
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
                
                
            }// end of if
            
            
        } // end of for loop
        
        // Update the delegate so the observing view will know that the download is done
        
        if let del = downloadDelegate {
           
            
            del.finishToDownloadPosts(posts)
        }
        
        
        
        
    }
}

