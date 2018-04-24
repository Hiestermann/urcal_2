//
//  Section2ButtonCell.swift
//  urcal
//
//  Created by Kilian Hiestermann on 03.06.17.
//  Copyright © 2017 Kilian Hiestermann. All rights reserved.
//

import UIKit

class Section2ButtonCell: SettingsCellStandart {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cellLabel.text = "Delete Account"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
