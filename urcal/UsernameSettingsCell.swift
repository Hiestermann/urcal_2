//
//  UsernameSettingsCell.swift
//  urcal
//
//  Created by Kilian Hiestermann on 03.06.17.
//  Copyright © 2017 Kilian Hiestermann. All rights reserved.
//

import UIKit

class UsernameSettingsCell: UICollectionViewCell, UITextFieldDelegate {
   
    var user: User? {
        didSet{
            
        }
    }
    
    let groundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let userImage: UIImageView = {
        let iv = UIImageView()
            iv.image = UIImage(named: "user_16")
        return iv
    }()
    
    lazy var usernameTextField: UITextField = {
        let tf = UITextField()
        tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return tf
    }()
    
    func textFieldDidChange(_ textField: UITextField) {
        NotificationCenter.default.post(name: .handleUsernameUserSettings, object: textField.text)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewAndButton()

    }
    
    fileprivate func setupViewAndButton() {
        
        addSubview(groundView)
        groundView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
       
        groundView.addSubview(userImage)
        userImage.anchor(top: nil, left: groundView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 16, height: 16)
        userImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        groundView.addSubview(usernameTextField)
        usernameTextField.anchor(top: nil, left: userImage.rightAnchor, bottom: nil, right: groundView.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
        usernameTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
