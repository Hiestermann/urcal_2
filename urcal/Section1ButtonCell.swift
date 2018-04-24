//
//  Section1ButtonCell.swift
//  urcal
//
//  Created by Kilian Hiestermann on 03.06.17.
//  Copyright © 2017 Kilian Hiestermann. All rights reserved.
//

import UIKit

class Section1ButtonCell: SettingsCellStandart {

    override init(frame: CGRect) {
        super.init(frame: frame)
        cellLabel.text = " Log Out"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
