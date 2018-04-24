//
//  ContainerView.swift
//  urcal
//
//  Created by Kilian on 24.04.18.
//  Copyright © 2018 Kilian Hiestermann. All rights reserved.
//

import UIKit

class ContainerView: UIView, UITextViewDelegate {
    let commentTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .red
        textView.font = .systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        return textView
    }()
    
    var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("send", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
        
        setupViews()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let commentTextViewHeight = commentTextView.frame.height
        if ( commentTextViewHeight < 150){
            commentTextView.isScrollEnabled = false
        }else {
            commentTextView.isScrollEnabled = true
        }
    }
    fileprivate func setupViews() {
        //addSubview(commentTextView)
        
        addSubview(submitButton)
        
        submitButton.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 5, width: 50, height: 50)
        
        commentTextView.delegate = self
        commentTextView.backgroundColor = .green
//        commentTextView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
