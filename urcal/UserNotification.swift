//
//  NotificationCenterStruct.swift
//  urcal
//
//  Created by Kilian on 04.06.18.
//  Copyright © 2018 Kilian Hiestermann. All rights reserved.
//

import Foundation

struct UserNotification {
    let postId: String
    let kind: String
    
    init(dictionary: [String: Any]) {
        self.postId = dictionary["postId"] as? String ?? ""
        self.kind = dictionary["kind"] as? String ?? ""
    }
}
