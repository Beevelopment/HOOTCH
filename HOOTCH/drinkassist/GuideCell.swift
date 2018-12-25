//
//  GuideCell.swift
//  drinkassist
//
//  Created by Carl Henningsson on 9/3/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit

class GuideCell: UICollectionViewCell {
    
    var page: GuideModel? {
        didSet {
            guard let page = page else {
                return
            }
            imageGuide.image = UIImage(named: page.imageName)
            
            let attributedText = NSMutableAttributedString(string: page.title, attributes: [NSAttributedStringKey.font: UIFont(name: GILL_SANS_BOLD, size: 24)!, NSAttributedStringKey.foregroundColor: MAIN_GREEN_COLOR])
            attributedText.append(NSAttributedString(string: "\n\n\(page.message)", attributes: [NSAttributedStringKey.font: UIFont(name: GILL_SANS, size: 16)!, NSAttributedStringKey.foregroundColor: SECONDARY_TEXT]))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let length = attributedText.string.count
            attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: length))
            
            textView.attributedText = attributedText
        }
    }
    
    let imageGuide: UIImageView = {
        let imgGuide = UIImageView()
        imgGuide.image = UIImage(named: "main-screen")
        imgGuide.contentMode = .scaleAspectFill
        imgGuide.clipsToBounds = true
        
        return imgGuide
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.text = "Some Sampel text"
        
        return tv
    }()
    
    let divider: UIView = {
        let div = UIView()
        div.backgroundColor = DIVIDERS
        
        return div
    }()
    
    let whiteView: UIView = {
        let wv = UIView()
        wv.backgroundColor = .white
        
        return wv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
//        margin
        let margin5procent = (UIApplication.shared.keyWindow?.frame.width)! / 20
        
//        add objects to view
        addSubview(imageGuide)
        addSubview(whiteView)
        addSubview(textView)
        addSubview(divider)
        
//        add constrains to object
        _ = imageGuide.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: margin5procent * 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = whiteView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: frame.height / 4)
        _ = textView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: margin5procent, bottomConstant: 0, rightConstant: margin5procent, widthConstant: 0, heightConstant: frame.height / 4)
        _ = divider.anchor(nil, left: leftAnchor, bottom: textView.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
