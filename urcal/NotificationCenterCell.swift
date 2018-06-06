//
//  NotificationCenterCell.swift
//  urcal
//
//  Created by Kilian on 03.06.18.
//  Copyright © 2018 Kilian Hiestermann. All rights reserved.
//

import UIKit
import FlexLayout

class NotificationCenterCell: UICollectionViewCell {
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "17:50 23.04.2018"
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "new comment on your post"
        label.numberOfLines = 2
        return label
    }()
    
    let rootview = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.flex.alignContent(.spaceBetween).define { (flex) in
            flex.addItem(dateLabel).marginLeft(5)
            flex.addItem().grow(1).direction(.row).define({ (flex) in
                flex.addItem().margin(10).grow(1).shrink(1).define({ (flex) in
                    flex.addItem(infoLabel)
                })
                flex.addItem().width(50).height(50).backgroundColor(.green)
                flex.addItem().width(50).height(50).backgroundColor(.brown).marginRight(10)
            })
            flex.addItem().height(1).backgroundColor(.lightGray).grow(1)
        }
    }
    
    public func configure() {
        infoLabel.flex.markDirty()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.flex.layout(mode: .adjustHeight)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        contentView.flex.layout(mode: .adjustHeight)
        return contentView.frame.size
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
