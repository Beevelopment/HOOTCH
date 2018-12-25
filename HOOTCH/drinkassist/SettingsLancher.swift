//
//  SettingsLancher.swift
//  drinkassist
//
//  Created by Carl Henningsson on 8/31/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit
import Lottie

class SettingsLancher: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let blackView: UIView = {
        let bv = UIView()
        bv.alpha = 0
        bv.backgroundColor = UIColor(white: 0, alpha: 0.5)
        bv.isUserInteractionEnabled = true
        
        return bv
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset.top = 50
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = MAIN_GREEN_COLOR
        
        return cv
    }()
    
    lazy var viewController: ViewController = {
        let vc = ViewController()
        vc.settingAcess = self
        
        return vc
    }()
    
    let dice: UIImageView = {
        let dice = UIImageView()
        dice.image = UIImage(named: "whitedice")
        dice.alpha = 0
        dice.contentMode = .scaleAspectFit
        
        return dice
    }()
    
    let bounesPoint: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.8)
        view.layer.shadowColor = UIColor(white: 1, alpha: 1).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1
        view.alpha = 0
        view.layer.cornerRadius = 1
        
        return view
    }()

    let cellID = "cellID"
    
    let settings: [SettingsModel] = {
        let guide = SettingsModel(image: "guide", titel: "Guide")
        let removeAds = SettingsModel(image: "ads", titel: "Remove Ads")
        let restoreAds = SettingsModel(image: "reload", titel: "Restore Purchase")
        let share = SettingsModel(image: "share", titel: "Share")
        let cancel = SettingsModel(image: "", titel: "Cancel")
        
        let array = [guide, removeAds, restoreAds, share, cancel]
        
        return array
    }()
    
    override init() {
        super.init()
    }
    
    func showSettings() {
        if let window = UIApplication.shared.keyWindow {
            let slideInViewWitdh = window.frame.width / 3 * 2
            let slideInViewHeight = window.frame.height
            let margin10procent = window.frame.width / 10
            
            collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellID)
            
            let cancelTap = UITapGestureRecognizer(target: self, action: #selector(cancelSettingsLancher))
            blackView.addGestureRecognizer(cancelTap)
            
            let rect = CGRect(x: -slideInViewWitdh, y: 0, width: slideInViewWitdh, height: slideInViewHeight)
            
//            Elements Added To View
            window.addSubview(blackView)
            window.addSubview(collectionView)
            window.addSubview(activityIndicator)
            
//            Elements Constraints
            _ = blackView.anchor(window.topAnchor, left: window.leftAnchor, bottom: window.bottomAnchor, right: window.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            collectionView.frame = rect
            _ = activityIndicator.anchor(blackView.topAnchor, left: blackView.leftAnchor, bottom: blackView.bottomAnchor, right: blackView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            
            activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
            
//            Animate View
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: 0, width: slideInViewWitdh, height: slideInViewHeight)
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let setting = settings[indexPath.item]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? SettingCell {
            cell.setting = setting
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexPath = indexPath.item
        if indexPath == 0 {
            cancelSettingsLancher()
            viewController.showGuideController()
        } else if indexPath == 1 {
            removeAds()
        } else if indexPath == 2 {
            cancelSettingsLancher()
            viewController.restorePurchase()
        } else if indexPath == 3 {
            cancelSettingsLancher()
            viewController.shareApplication()
        } else if indexPath == 4 {
            cancelSettingsLancher()
        }
    }
    
    let drinkanimation = LOTAnimationView()
    
    func animateDice() {
        if let window = UIApplication.shared.keyWindow {
            
            drinkanimation.setAnimation(named: "drink")
            
            window.addSubview(drinkanimation)
            
            _ = drinkanimation.anchor(window.topAnchor, left: window.leftAnchor, bottom: window.bottomAnchor, right: window.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            
            drinkanimation.play()
            
//            let size = window.frame.width / 7
//            let imageSize = CGSize(width: size, height: size)
//            let origin = CGPoint(x: (window.frame.width / 2 - size / 2), y: (window.frame.height / 2 - size / 2))
//
//            window.addSubview(blackView)
//            window.addSubview(bounesPoint)
//            window.addSubview(dice)
//
//            _ = blackView.anchor(window.topAnchor, left: window.leftAnchor, bottom: window.bottomAnchor, right: window.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
//            dice.frame = CGRect(origin: origin, size: imageSize)
//
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//                self.blackView.alpha = 1
//                self.dice.alpha = 1
//                self.dice.startRotating(duration: 1)
//            }, completion: nil)
        }
    }
    
    func stopAnimateDice() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            self.dice.alpha = 0
            self.dice.stopRotating()
        })  { (Bool) in
            if Bool {
                DispatchQueue.main.async {
                    self.viewController.randomizer()
                }
            }
        }
    }
    
    @objc func removeAds() {
        let window = UIApplication.shared.keyWindow
        let slideInViewWitdh = window!.frame.width / 3 * 2
        let slideInViewHeight = window!.frame.height
        
        activityIndicator.startAnimating()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.collectionView.frame = CGRect(x: -slideInViewWitdh, y: 0, width: slideInViewWitdh, height: slideInViewHeight)
        })  { (Bool) in
            if Bool {
                PurchaseManaager.instance.purchaseRemoveAds { success in
                    if success {
                        bannerView.removeFromSuperview()
                        self.cancelSettingsLancher()
                        activityIndicator.stopAnimating()
                        activityIndicator.transform = CGAffineTransform(scaleX: 1, y: 1)
                    } else {
                        self.cancelSettingsLancher()
                    }
                }
            }
        }
    }
    
    func cancelSettingsLancher() {
        let window = UIApplication.shared.keyWindow
        let slideInViewWitdh = window!.frame.width / 3 * 2
        let slideInViewHeight = window!.frame.height
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.collectionView.frame = CGRect(x: -slideInViewWitdh, y: 0, width: slideInViewWitdh, height: slideInViewHeight)
            self.blackView.alpha = 0
            activityIndicator.stopAnimating()
        }, completion: nil)
    }
}

let kAnimationKey = "rotation"

extension UIView {
    func startRotating(duration: Double) {
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = Float(Double.pi * 2)
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    
    func stopRotating() {
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
}
