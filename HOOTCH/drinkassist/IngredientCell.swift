//
//  IngredientCell.swift
//  drinkassist
//
//  Created by Carl Henningsson on 8/26/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit
import Foundation

class IngredientCell: UITableViewCell {
    
    let ingredientLable: UILabel = {
        let ingredientLbl = UILabel()
        ingredientLbl.textColor = PRIMARY_TEXT
        ingredientLbl.font = UIFont(name: GILL_SANS, size: 16)!
        
        return ingredientLbl
    }()
    
    let checkImage: UIImageView = {
        let checkImg = UIImageView()
        checkImg.image = UIImage(named: "check")
        
        return checkImg
    }()
    
    let divider: UIView = {
        let div = UIView()
        div.backgroundColor = DIVIDERS
        
        return div
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var showing = false

    var ingredient: Ingredient!
    var key: String?
    
    func configureIngredientCell(lable: Ingredient, isSelected: Bool) {
        self.ingredient = lable
        self.ingredientLable.text = lable.INGREDIENT
        self.selectionStyle = .none
        key = lable.POST_ID
        
        if isSelected {
            self.checkImage.isHidden = false
        } else {
            self.checkImage.isHidden = true
        }
        
        placeElements()
    }
    
    func configureFiltredIngredients(lable: String, isSelected: Bool, postId: String) {
        self.ingredientLable.text = lable
        key = postId
        
        if isSelected {
            self.checkImage.isHidden = false
        } else {
            self.checkImage.isHidden = true
        }
        
        placeElements()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            if !ViewController.ingredientsInBasket.contains(ingredientLable.text!) {
                checkImage.isHidden = false
            } else {
                checkImage.isHidden = true
            }
        }
    }

    func placeElements() {
    
        addSubview(ingredientLable)
        addSubview(checkImage)
        addSubview(divider)
        
        _ = ingredientLable.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 5, leftConstant: 0, bottomConstant: 5, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = checkImage.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 20, heightConstant: 20)
        _ = divider.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: -0.5, rightConstant: 0, widthConstant: 0, heightConstant: 1)
    }
}
