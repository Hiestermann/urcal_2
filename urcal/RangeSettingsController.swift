//
//  RangeSettings.swift
//  urcal
//
//  Created by Kilian Hiestermann on 07.06.17.
//  Copyright © 2017 Kilian Hiestermann. All rights reserved.
//

import UIKit

class RangeSettingsController: UIViewController {

    let defaults = UserDefaults.standard
    
    //MARK: -setting up views and buttons
    let groundView: UIView = {
       let gv = UIView()
        gv.backgroundColor = .white
        return gv
    }()
    
    let rangeSlider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 200
        slider.minimumValue = 1
        slider.addTarget(self, action: #selector(handleRangeLabel), for: .valueChanged)
        return slider
    }()
    
    var rangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.setTitle("save", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        button.addTarget(self, action: #selector(saveRange), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    let lowerView: UIView = {
        let lv = UIView()
        
        //NOTE: adding tap gesture recognizer to dismiss the view by tapping on the blank field
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView(_:)))
        lv.addGestureRecognizer(tap)
        
        return lv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        view.isOpaque = false
        
        setupView()
        
    }
    
    //MARK: -setup Views
    fileprivate func setupView() {
        view.addSubview(groundView)
        groundView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        view.addSubview(rangeSlider)
        rangeSlider.anchor(top: nil, left: groundView.leftAnchor, bottom: nil, right: groundView.rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: -15, width: 0, height: 20)
        rangeSlider.centerYAnchor.constraint(equalTo: groundView.centerYAnchor).isActive = true
        
        view.addSubview(rangeLabel)
        rangeLabel.anchor(top: groundView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 20)
        rangeLabel.centerXAnchor.constraint(equalTo: groundView.centerXAnchor).isActive = true
        
        //NOTE: -get the current range value
        let range = Float(defaults.integer(forKey: "range"))
        let currentRange = Int(range)
        rangeSlider.value = Float(currentRange)
        rangeLabel.text = String(currentRange)
        
        view.addSubview(saveButton)
        saveButton.anchor(top: groundView.bottomAnchor, left: groundView.leftAnchor, bottom: nil, right: groundView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    }
    
    //MARK: -save Range
    func saveRange() {
        let range = Int(rangeSlider.value)
        let defaults = UserDefaults.standard
        defaults.set(range, forKey: "range")
        print(defaults.integer(forKey: "range"))
        
        //MARK: -reload and dismiss View
        NotificationCenter.default.post(name: .refreshHomeController , object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: -update rangeLabel
    func handleRangeLabel(sender: UISlider) {
        
        let value = Int(sender.value)
        rangeLabel.text = String(value)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: -dismiss view by tap
    func dismissView (_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

}