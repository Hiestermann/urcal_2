//
//  UserEditeHeaderReusable.swift
//  urcal
//
//  Created by Kilian Hiestermann on 03.06.17.
//  Copyright © 2017 Kilian Hiestermann. All rights reserved.
//

import UIKit

class UserEditSectionHeaderView: UICollectionReusableView {
    
    var user: User? = nil
    
    //MARK: -views and buttons
    let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 25
        return iv
    }()
    
    lazy var changeProfilePicture: UIButton = {
        let button = UIButton()
        button.setTitle("Change Profile Picture", for: .normal)
        button.backgroundColor = .red
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleChangeProfilePicture), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
         super.init(frame: frame)
        setupView()
        backgroundColor = UIColor(white: 1, alpha: 0.9)
        NotificationCenter.default.addObserver(self, selector: #selector(setUserImage), name: .setUserImage, object: nil)
    }
    
    func setUserImage(notification: Notification){
        guard let image = notification.object as? UIImage else { return }
        userImageView.image = image
    }
    
    func setupView() {
        
        addSubview(userImageView)
        userImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        userImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(changeProfilePicture)
        changeProfilePicture.anchor(top: nil, left: userImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 200, height: 20)
        changeProfilePicture.centerYAnchor.constraint(equalTo:  centerYAnchor).isActive = true
        
    }
    
    func handleChangeProfilePicture() {
        NotificationCenter.default.post(name: .showPhotoSelector, object: nil)
    }


}
