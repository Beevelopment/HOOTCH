//
//  SettingCell.swift
//  drinkassist
//
//  Created by Carl Henningsson on 10/14/18.
//  Copyright © 2018 Henningsson Company. All rights reserved.
//

import UIKit

class SettingCell: UICollectionViewCell {
    
    var setting: SettingsModel? {
        didSet {
            titel.text = setting?.titel
            if let imageName = setting?.image {
                imgView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    let imgView: UIImageView = {
        let img = UIImageView()
        img.tintColor = .white
        img.contentMode = .scaleAspectFit
        img.contentMode = .scaleAspectFit
        
        return img
    }()
    
    let titel: UILabel = {
        let t = UILabel()
        t.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        t.textColor = .white
        t.textAlignment = .left
        
        return t
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    private func setupCell() {
        backgroundColor = MAIN_GREEN_COLOR
        
        let margin = frame.width / 10
        
        addSubview(imgView)
        addSubview(titel)
        
        _ = imgView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: margin, bottomConstant: 0, rightConstant: 0, widthConstant: 25, heightConstant: 25)
        _ = titel.anchor(topAnchor, left: imgView.rightAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: margin / 2, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
