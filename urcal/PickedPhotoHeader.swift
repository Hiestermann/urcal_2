//
//  PickedPhotoHeader.swift
//  urcal
//
//  Created by Kilian Hiestermann on 09.05.17.
//  Copyright © 2017 Kilian Hiestermann. All rights reserved.
//

import UIKit

class PickedPhotoHeader: UICollectionViewCell {
    
    //MARK: -views
    var imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isMultipleTouchEnabled = true
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
