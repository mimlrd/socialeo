//
//  CommentVC.swift
//  socialeo
//
//  Created by Mike Milord on 14/09/2018.
//  Copyright © 2018 First Republic. All rights reserved.
//

import UIKit

class CommentVC: UIViewController {
    
    @IBOutlet weak var commentFeedCollection: UICollectionView!
    
    @IBOutlet weak var inputTextView: InputTextView!
    
    @IBOutlet weak var textViewContainerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textViewContainerBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    private var comments: [InstaComment]?
    
    var selectedPostID: String?
    
    private let cellName = IDENTIFIERS.commentCellIdentifier
    
    
    lazy var layoutCell : UICollectionViewFlowLayout? = {
        return self.commentFeedCollection?.collectionViewLayout as! UICollectionViewFlowLayout?
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        performCommentDownload() // To download the comments

        let swipeGesture = UISwipeGestureRecognizer(target: self , action: #selector(swipeDownGesture(swipe:)))
        swipeGesture.direction = .down
        inputTextView.addGestureRecognizer(swipeGesture)
        
        inputTextView.delegate = self
        inputTextView.placeholder = NSLocalizedString("Write your message here ...", comment: "Message Placeholder")
        
        //To make the keyboard interactively dismiss
        commentFeedCollection.keyboardDismissMode = .interactive
        
        setupNavBar()
        configureCollectionView()
        configureNotifications()
        
        // TODO: we can add a later date eaither an observer to show when new comments have been added to the server, the view will need to fetch them OR we can add a refresh function with a pull collectionView to reload
        
    }
    
    fileprivate func performCommentDownload(){
        // Download the posts from Instagram servers
        
        if let postId = selectedPostID {
            let apiServices = ApiServices()
            apiServices.downloadDelegate = self
            apiServices.fetchCommentForPost(postId)
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        // Remove all the notification observers to avoid retain cycle -> memory leaks
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNavBar() {
        // Setup the title bar, we can customise the text here or add a logo instead
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width , height: view.frame.height ))
        titleLabel.text = "comments"
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont(name: "AvenirNext-Medium", size: 25)
        titleLabel.textColor = .black
        navigationItem.titleView = titleLabel
    }
    
    
    private func configureNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    func configureCollectionView() {
        /// All collectionView configuration will be done here
        /// it will be easier to maintain in the long run
        commentFeedCollection.dataSource = self

        commentFeedCollection.alwaysBounceVertical = true
        let nib = UINib(nibName: IDENTIFIERS.nibCommentCell, bundle: nil)
        commentFeedCollection.register(nib, forCellWithReuseIdentifier: cellName)
        layoutCell?.minimumLineSpacing = 5.0
        layoutCell?.sectionInset.bottom = textViewContainerHeightConstraint.constant + 20
        layoutCell?.estimatedItemSize = CGSize(width: 1, height: 1)

    }
    
    
    @objc private func handleKeyboardNotification(notification: NSNotification){
        
        if let userInfo = notification.userInfo {
            
            guard let keyboardFrame: CGRect = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else {return}
            let keyboardDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
            
            if #available(iOS 11.0, *) {
                // Running iOS 11 OR NEWER
                textViewContainerBottomConstraint.constant = -(keyboardFrame.height - view.safeAreaInsets.bottom)
                UIView.animate(withDuration: keyboardDuration) {
                    self.view.layoutIfNeeded()
                }
            } else {
                // Earlier version of iOS
                textViewContainerBottomConstraint.constant = -(keyboardFrame.height)
                UIView.animate(withDuration: keyboardDuration) {
                    self.view.layoutIfNeeded()
                }

            }
            
            view.layoutIfNeeded()
            
        }
        
    }
    
    //: Mark - let the user swipe down on the inputtextfield to dismiss keyboard
    
    @objc private func swipeDownGesture(swipe: UISwipeGestureRecognizer) {
        
        if swipe.direction == .down {
             inputTextView.resignFirstResponder()
        }
        
    }
    
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        // hidding the keyboard, therefore, bringing dow the textfield container
        
        if let userInfo = notification.userInfo {
            let keyboardDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
            textViewContainerBottomConstraint.constant = 0.0
            UIView.animate(withDuration: keyboardDuration) {
                self.view.layoutIfNeeded()
            }
            
        }
        
        
    }

   
}

extension CommentVC: FinishDownloadDelegate {
    
    // the custom delegate function which is called when the comments have been downloaded from the server
    func finishToDownloadPosts<T>(_ elements: [T]) {
        
        guard let download_comments = elements as? [InstaComment] else {return}
        
        self.comments = download_comments.sorted(by: { (comment1, comment2) in
            
            comment1.timestamp > comment2.timestamp
        })
        
        DispatchQueue.main.async {
            self.commentFeedCollection.reloadData()
        }
    }
}


extension CommentVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let width = textView.frame.width
        let size = CGSize(width: width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textViewHeightConstraint.constant = estimatedSize.height
        textViewContainerHeightConstraint.constant = textViewHeightConstraint.constant + IDENTIFIERS.marginTextViewHeight
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        //inputTextView.placeholder = ""
        inputTextView.removePlaceholder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            //inputTextView.placeholder = ""
            inputTextView.addPlaceholder()
        }
    }
    
}

extension CommentVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.comments?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as? CommentCell, let all_coments = comments else {return UICollectionViewCell()} // Falling with grace if there is no cell available
        
        // Pasing the comment to the cell to display
        cell.comment = all_coments[indexPath.row]
        
        return cell
    }
    

    
    
}


