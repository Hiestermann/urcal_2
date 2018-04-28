//
//  CommentsController.swift
//  urcal
//
//  Created by Kilian on 16.04.18.
//  Copyright © 2018 Kilian Hiestermann. All rights reserved.
//

import UIKit
import Firebase

extension CommentsController: ContainerViewDelegate {
    func handleSend(text: String) {
        guard let postID = postID else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["text": text, "uid": uid] as [String : Any]
        
        let ref = Database.database().reference().child("Comments").child(postID).childByAutoId()
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                print(err)
            }
        }
        collectionView?.reloadData()
    }
}

class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
   
    var comments = [Comment]()
    
    var postID: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: "cellID")
        fetchPostComments()
    }
    
     init(collectionViewLayout layout: UICollectionViewLayout, postID: String) {
        super.init(collectionViewLayout: layout)
        self.postID = postID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func fetchPostComments() {
        guard let postID = postID else {return}
        Database.database().reference().child("Comments").child(postID).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let commentsDictionary = snapshot.value as? [String: Any] else { return }
            let key = snapshot.key
            let comment = Comment(commentID: key, dictionary: commentsDictionary)
            print(comment)
            self.comments.append(comment)
        }) { (err) in
            print(err)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! CommentCell
        cell.commentText.text = comments[indexPath.row].text
        cell.backgroundColor = .blue
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    lazy var containerView: UIView = {
        let containerView = ContainerView()
        containerView.delegate = self
        var containerHeight: CGFloat = 50
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: containerHeight)
         return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 100)
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
}
