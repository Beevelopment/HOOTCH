//
//  AboutCell.swift
//  drinkassist
//
//  Created by Carl Henningsson on 9/3/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit

class AboutCell: UICollectionViewCell {
    
    var about: AboutModel? {
        didSet {
            titleLabel.text = about?.title
            textOfTitle.text = about?.text
        }
    }
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Terms of use"
        lbl.textColor = .white
        lbl.font = UIFont(name: GILL_SANS, size: 24)!
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    let textOfTitle: UILabel = {
        let txt = UILabel()
        txt.text = "By using HOOTCH you are agreeing to our terms of use. The application uses Firebase as its database and for monetizing the users behavior when application is in use. Therefore we encourage you to read their terms of use. You find a link below. For the application to work properly we are using your phones specific id. This is only used to store the ingredients you are choosing for the drink. The application is for those who are 18 years old or older. We do not take responsibility for the users under the age limit. And for privacy reasons we can’t check how old the user is. For advertising we use AdMob and for the privacy details read AdMobs terms, link below."
        txt.textColor = .white
        txt.textAlignment = .left
        txt.font = UIFont(name: GILL_SANS, size: 16)!
        txt.numberOfLines = 0
        
        return txt
    }()
    
    var showing = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        placeObjectsInCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func placeObjectsInCell() {
        
        let margin5procent = (UIApplication.shared.keyWindow?.frame.width)! / 20
        let margin2precent = margin5procent / 2
        
        addSubview(titleLabel)
        addSubview(textOfTitle)
        
        _ = titleLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: margin2precent, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = textOfTitle.anchor(titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: margin5procent, leftConstant: 0, bottomConstant: margin5procent, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
}
