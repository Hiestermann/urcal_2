//
//  UserPostsView.swift
//  urcal
//
//  Created by Kilian Hiestermann on 25.05.17.
//  Copyright © 2017 Kilian Hiestermann. All rights reserved.
//

import UIKit
import Firebase

class UserPostsView: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var user: User?
    var posts = [Post]()
    
    let cellId = "cellID"
    let headerId = "headerID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear"), style: .plain, target: self, action: #selector(showUserSettings))
        
        fetchUser()
        fetchUserPosts()
        
        collectionView?.register(HomeControllerViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(UserPostHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(showUserSettings), name: .showUserEdit, object: nil)
    }
    
    func handleRefreshUser () {
        fetchUser()
        collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.width / 2) + 118
        return CGSize(width: view.frame.width, height: height)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeControllerViewCell
        if let user = user {
            let post = UserPost(user: user, post: posts[indexPath.item])
            cell.post = post
        }
        
        return cell
    }
   
    fileprivate func fetchUserPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(uid).child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let postIdDictionary = snapshot.value as? [String: Any] else { return }
            postIdDictionary.forEach({ (key, value) in
                Database.fetchPostWithId(postId: key, completion: { (post) in
                    self.posts.append(post)
                    self.collectionView?.reloadData()
                })
            })
            
        }) { (err) in
            print(err)
        }
    }
    
    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        Database.fetchUserWithUid(uid: uid) { (user) in
            self.user = user
            self.collectionView?.reloadData()
        }
    }
    
    func showUserSettings() {
        guard let user = self.user else { return }
        let layout = UICollectionViewFlowLayout()
        let userEdit = UserSettings(collectionViewLayout: layout)
        userEdit.user = user
        navigationController?.modalPresentationStyle = .overCurrentContext
        navigationController?.pushViewController(userEdit, animated: true)
    }
    
    func showPostEdit(post: Post){
        let userPostEdit = UserPostEdit()
        userPostEdit.post = post
        navigationController?.pushViewController(userPostEdit, animated: true)
    }
}

extension UserPostsView: UserPostHeaderDelegate {
    func didTapEditProfile() {
        let layout = UICollectionViewFlowLayout()
        let userSettings = UserSettings(collectionViewLayout: layout)
        self.navigationController?.pushViewController(userSettings, animated: true)
    }
    
    
}
