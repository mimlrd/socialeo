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
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    var isZooming: Bool = false
    var originalImageCenter:CGPoint?
    var selectedPostID: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitleLabl()
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
    
    
    func setTitleLabl() {
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height ))
        titleLabel.text = "socialeo"
        titleLabel.font = UIFont(name: "AvenirNex-Medium", size: 20)
        titleLabel.textColor = .black
        navigationItem.titleView = titleLabel
        
        setupNavbarButtons()
    }
    
    
    func setupNavbarButtons() {
        
        
        let statsImage = UIImage(named: "stats.png")
        
        let statsBarBtn = UIBarButtonItem(image: statsImage, style: .plain, target: self, action: #selector(pushStatsButton))
        statsBarBtn.tintColor = .black // Change the colour to black to adapt to the feel and look of the app
    
        
        navigationItem.rightBarButtonItems = [statsBarBtn]
    }
    
    
    @objc fileprivate func pushStatsButton(){
        getTheSocialStatsForUser()

    }
    
    private func getTheSocialStatsForUser(){
        
        guard let socialStatsDict  = UserDefaults.standard.dictionary(forKey: "socialStats") as? [String:Int] else {return}
        
        if let nbrofPost = socialStatsDict["nbrOfPosts"],
            let nbrOfLike = socialStatsDict["nbrOfLikes"],
            let nbrOfComment = socialStatsDict["nbrOfComments"]  {
            
            // we will create the social stats object to pass to the alert view
            let socialStats = SocialStat(nbrOfPost: nbrofPost , nbrOfLike: nbrOfLike , nbrOfComment: nbrOfComment )
            
            let alert = CustomStatsAlert(forSocialStats: socialStats)
            alert.show(animated: true)
            
            
        }
    }
    
    
    //Mark: - segue to the commentVC
    
    
    func pushView(withPostId id:String) {
        self.selectedPostID = id
        self.performSegue(withIdentifier: IDENTIFIERS.seguehomeVCToCommentVC, sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == IDENTIFIERS.seguehomeVCToCommentVC {
            if let vc = segue.destination as? CommentVC {
                
               vc.selectedPostID = self.selectedPostID
            }
        }
        
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
        cell.homeVC = self // to allow the cell to call specific functions
        
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

extension HomeVC: UIGestureRecognizerDelegate {

    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    // custom zooming logic
    func performZoomInForStartingImageView(_ startingImageView: UIImageView) {
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.red
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleZoomOut))
        tapGesture.numberOfTapsRequired = 1
        zoomingImageView.addGestureRecognizer(tapGesture)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
        pinch.delegate = self
        zoomingImageView.addGestureRecognizer(pinch)
        
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackBackgroundView?.alpha = 1
                
                // math?
                // h2 / w1 = h1 / w1
                // h2 = h1 / w1 * w1
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                zoomingImageView.center = keyWindow.center
                
            }, completion: { (completed) in
                // do nothing
            })
            
        }
    }
    
    @objc func handleZoomOut(_ tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            //need to animate back out to controller
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                
            }, completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })
        }
    }
    
    
    @objc func pinch(sender:UIPinchGestureRecognizer) {
        
        guard let imageView = sender.view  else {return}
        
        if sender.state == .began {
            let currentScale = imageView.frame.size.width / imageView.bounds.size.width
            let newScale = currentScale*sender.scale
            if newScale > 1 {
                self.isZooming = true
            }
        } else if sender.state == .changed {
            guard let view = sender.view else {return}
            let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX,
                                      y: sender.location(in: view).y - view.bounds.midY)
            let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: sender.scale, y: sender.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            let currentScale = imageView.frame.size.width / imageView.bounds.size.width
            var newScale = currentScale*sender.scale
            if newScale < 1 {
                newScale = 1
                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                imageView.transform = transform
                sender.scale = 1
            }else {
                view.transform = transform
                sender.scale = 1
            }
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            guard let center = self.originalImageCenter else {return}
            UIView.animate(withDuration: 0.3, animations: {
                imageView.transform = CGAffineTransform.identity
                imageView.center = center
            }, completion: { _ in
                self.isZooming = false
            })
        }
    }
    

}


