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
    
    var comments: [InstaComment]?
    
    let cellName = IDENTIFIERS.commentCellIdentifier
    
    
    lazy var layoutCell : UICollectionViewFlowLayout? = {
        return self.commentFeedCollection?.collectionViewLayout as! UICollectionViewFlowLayout?
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

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
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNavBar() {
        
        self.navigationItem.title = "COMMENTS"
    }
    
    
    private func configureNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    func configureCollectionView() {
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
        return self.comments?.count ?? 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as? CommentCell else {return UICollectionViewCell()} // Falling with grace if there is no cell available
        
        
        return cell
    }
    
}
