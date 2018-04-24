//
//  UserPostsView.swift
//  urcal
//
//  Created by Kilian Hiestermann on 25.05.17.
//  Copyright © 2017 Kilian Hiestermann. All rights reserved.
//

import UIKit
import Firebase

class UserPostsView: UITableViewController{
    
    var user: User?
    var posts = [Post]()
    
    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    let cellId = "cellId"
    let headerId = "headerId"
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear"), style: .plain, target: self, action: #selector(showUserSettings))
        
        fetchUser()
        fetchUserPosts()
        
        tableView.register(UserPostsCells.self, forCellReuseIdentifier: cellId)
        tableView.register(UserPostHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showUserSettings), name: .showUserEdit, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefreshUser), name: .refreshUserPostView, object: nil)
    }
    
    func handleRefreshUser () {
        fetchUser()
        tableView.reloadData()
    }
    
   
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! UserPostHeader
        header.user = user
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if posts.count == 0 {
        
            self.view.addSubview(backView)
            backView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            return 0
        
        }else {
        
        return posts.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserPostsCells
        cell.post = posts[indexPath.item]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showPostEdit(post: posts[indexPath.item])
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let uid = posts[indexPath.item].uid
        let postId = posts[indexPath.item].postId
        
        Database.database().reference().child("posts").child(postId).removeValue()
        Database.database().reference().child("users").child(uid).child("posts").child(postId).removeValue()
        posts.remove(at: indexPath.item)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    fileprivate func fetchUserPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(uid).child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let postIdDictionary = snapshot.value as? [String: Any] else { return }
            postIdDictionary.forEach({ (key, value) in
                Database.fetchPostWithId(postId: key, completion: { (post) in
                    self.posts.append(post)
                    self.tableView.reloadData()
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
            self.tableView.reloadData()
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
