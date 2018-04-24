//
//  ButtonCellStandart.swift
//  urcal
//
//  Created by Kilian Hiestermann on 03.06.17.
//  Copyright © 2017 Kilian Hiestermann. All rights reserved.
//

import UIKit

class SettingsCellStandart: UICollectionViewCell {

    //MARK: -views and buttons
    let cellLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let groundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    //MARK: -set up views
    fileprivate func setUpViews() {
        
        cellLabel.textColor = .red
        addSubview(groundView)
        groundView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: -5, width: 0, height: 0)
        addSubview(cellLabel)
        cellLabel.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: groundView.frame.width, height: 50)
        cellLabel.centerXAnchor.constraint(equalTo: groundView.centerXAnchor).isActive = true
        cellLabel.centerYAnchor.constraint(equalTo: groundView.centerYAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
