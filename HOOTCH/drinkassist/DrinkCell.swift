//
//  DrinkCell.swift
//  drinkassist
//
//  Created by Carl Henningsson on 8/31/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit
import Firebase

class DrinkCell: UICollectionViewCell {
    
    let divider: UIView = {
        let d = UIView()
        d.backgroundColor = DIVIDERS
        
        return d
    }()
    
    let drinkLabel: UILabel = {
        let dl = UILabel()
        dl.font = UIFont(name: GILL_SANS, size: 16)!
        dl.textColor = PRIMARY_TEXT
        
        return dl
    }()
    
    var drinkModel: DrinkModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    func setupCell(model: DrinkModel) {
        self.drinkLabel.text = model.name
        
        placeObjectsInCell()
    }
    
    func placeObjectsInCell() {
//        Place Elements
        addSubview(divider)
        addSubview(drinkLabel)
        
//        Place Constraints
        _ = divider.anchor(bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: -0.5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        _ = drinkLabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 5, leftConstant: 0, bottomConstant: 5, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
