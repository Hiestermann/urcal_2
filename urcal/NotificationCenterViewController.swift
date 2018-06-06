//
//  NotificationCenterView.swift
//  urcal
//
//  Created by Kilian on 04.06.18.
//  Copyright © 2018 Kilian Hiestermann. All rights reserved.
//

import UIKit
import Firebase

class NotificationCenterViewController: UIViewController {
    fileprivate var mainView: NotificationCenterView {
        return self.view as! NotificationCenterView
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = NotificationCenterView()
        fetchNotifications()
        mainView.configure()
    }
    
    func fetchNotifications() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value.debugDescription)
            
        }) { (err) in
            print(err)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
