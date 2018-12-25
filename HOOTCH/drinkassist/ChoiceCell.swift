//
//  CategoryCell.swift
//  drinkassist
//
//  Created by Carl Henningsson on 10/7/18.
//  Copyright © 2018 Henningsson Company. All rights reserved.
//

import UIKit

class ChoiceCell: UICollectionViewCell {
    
    var choice: ChoiceModel? {
        didSet {
            choiceLabel.text = "Search for \(choice!.label)"
            if let img = choice?.image {
                image.image = UIImage(named: img)
            }
        }
    }
    
    let image: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        
        return img
    }()
    
    let choiceLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = SECONDARY_TEXT
        lbl.font = UIFont(name: GILL_SANS, size: 18)!
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    

    func setupCell() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowColor = SHADOW_COLOR
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 1
        
        let imageSize = frame.height / 10 * 6
        
        addSubview(image)
        addSubview(choiceLabel)
        
        let margin = frame.height / 10 * 2
        
        _ = image.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: margin, leftConstant: margin, bottomConstant: margin, rightConstant: 0, widthConstant: imageSize, heightConstant: imageSize)
        _ = choiceLabel.anchor(topAnchor, left: image.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: margin, bottomConstant: 0, rightConstant: margin, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
