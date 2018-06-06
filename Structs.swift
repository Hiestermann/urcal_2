//
//  struckts.swift
//  urcal
//
//  Created by Kilian Hiestermann on 10.05.17.
//  Copyright © 2017 Kilian Hiestermann. All rights reserved.
//

import UIKit

struct User {
    var uid: String
    let username: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageURL"] as? String ?? ""
    }
    
}

struct Comment{
    let commendID: String
    let text: String
    let uid: String
    
    init(commentID: String, dictionary: [String: Any]) {
        self.commendID = commentID
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}


struct Post{
    let imageUrl: String
    let uid: String
    let captionText: String
    let imageWidth: String
    let imageSize: String
    let creationDate: Date
    let longitude: Double
    let latitude: Double
    let postId: String
    let imageName: String
    let geoImageUrl:String
    let geoImageName: String
    
    init(postId: String, dictionary: [String: Any]) {
        self.postId = postId
        self.uid = dictionary["uid"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.imageName = dictionary["imageName"] as? String ?? ""
        self.captionText = dictionary["text"] as? String ?? ""
        self.imageWidth = dictionary["imageWidth"] as? String ?? ""
        self.imageSize = dictionary["imageSize"] as? String ?? ""
        self.longitude = dictionary["longitude"] as? Double ?? 10.01534
        self.latitude = dictionary["latitude"] as? Double ?? 53.57532
        self.geoImageUrl = dictionary["geoImageUrl"] as? String ?? ""
        self.geoImageName = dictionary["geoImageName"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }

}

struct UserPost{
    let user: User
    let post: Post
    
    init(user: User, post: Post) {
        self.user = user
        self.post = post
    }
    
}

