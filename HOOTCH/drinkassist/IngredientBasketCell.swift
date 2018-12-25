//
//  IngredientBasketCell.swift
//  drinkassist
//
//  Created by Carl Henningsson on 8/29/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import Foundation
import UIKit

class IngredientBasketCell: UITableViewCell {
    
    let divider: UIView = {
        let div = UIView()
        div.backgroundColor = DIVIDERS
        
        return div
    }()
    
    let ingredientLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = MAIN_GREEN_COLOR
        lbl.font = UIFont(name: GILL_SANS, size: 16)!
        
        return lbl
    }()
    
    func setupCell(ingredient: String) {
        self.ingredientLabel.text = ingredient
        placeElements()
    }
    
    func placeElements() {
        addSubview(ingredientLabel)
        addSubview(divider)
        
        _ = ingredientLabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 5, leftConstant: 0, bottomConstant: 5, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = divider.anchor(bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: -0.5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


















