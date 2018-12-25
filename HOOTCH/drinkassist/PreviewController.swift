//
//  PreviewController.swift
//  drinkassist
//
//  Created by Carl Henningsson on 10/11/18.
//  Copyright © 2018 Henningsson Company. All rights reserved.
//

import UIKit

class PreviewController: UIViewController {
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var imgView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "icon")
        img.contentMode = .scaleAspectFill
        img.layer.masksToBounds = true
        
        return img
    }()
    
    lazy var drinkName: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.text = "Gin & Tonic"
        lbl.textColor = MAIN_GREEN_COLOR
        lbl.font = UIFont(name: GILL_SANS_BOLD, size: 32)!
        lbl.adjustsFontSizeToFitWidth = true
        
        return lbl
    }()
    
    let shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = MAIN_GREEN_COLOR.cgColor
        layer.lineWidth = 10
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeEnd = 0
        layer.lineCap = kCALineCapRound
        
        return layer
    }()
    
    let trackLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.lightGray.cgColor
        layer.lineWidth = 10
        layer.fillColor = UIColor.clear.cgColor
        
        return layer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPreviewController()
        
    }
    
    private func setupPreviewController() {
        
        let imageSize = view.frame.width / 2
        let imageSpace = imageSize / 2
        let sideMargin = view.frame.height / 20
        
        let placeShapeLayer = CGPoint(x: imageSpace, y: imageSpace)
        let circularPath = UIBezierPath(arcCenter: placeShapeLayer, radius: imageSpace, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        shapeLayer.path = circularPath.cgPath
        
        imgView.layer.cornerRadius = imageSpace
        
        imgView.layer.addSublayer(trackLayer)
        imgView.layer.addSublayer(shapeLayer)
        
        view.addSubview(container)
        container.addSubview(imgView)
        container.addSubview(drinkName)
        
        _ = container.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = imgView.anchor(container.topAnchor, left: container.leftAnchor, bottom: nil, right: container.rightAnchor, topConstant: sideMargin, leftConstant: imageSpace, bottomConstant: 0, rightConstant: imageSpace, widthConstant: imageSize, heightConstant: imageSize)
        _ = drinkName.anchor(imgView.bottomAnchor, left: container.leftAnchor, bottom: nil, right: container.rightAnchor, topConstant: sideMargin / 2, leftConstant: sideMargin, bottomConstant: 0, rightConstant: sideMargin, widthConstant: 0, heightConstant: 0)
    }

}
