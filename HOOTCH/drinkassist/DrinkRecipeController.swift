//
//  DrinkRecipeController.swift
//  drinkassist
//
//  Created by Carl Henningsson on 9/2/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit
import Firebase

class DrinkRecipeController: UIViewController, URLSessionDownloadDelegate {

//    Dismiss Button
    let dismissButton: UIButton = {
        let dismissBtn = UIButton(type: .custom)
        dismissBtn.setImage(UIImage(named: "closeBtn")?.withRenderingMode(.alwaysTemplate), for: .normal)
        dismissBtn.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        dismissBtn.tintColor = MAIN_GREEN_COLOR
        
        return dismissBtn
    }()
    
    let shareButton: UIButton = {
        let shareBtn = UIButton(type: .custom)
        shareBtn.setImage(UIImage(named: "share")?.withRenderingMode(.alwaysTemplate), for: .normal)
        shareBtn.addTarget(self, action: #selector(shareApplication), for: .touchUpInside)
        shareBtn.tintColor = MAIN_GREEN_COLOR
        
        return shareBtn
    }()
    
    lazy var imgView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "icon")
        img.contentMode = .scaleAspectFill
        img.layer.masksToBounds = true
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handelZoom)))
        
        return img
    }()
    
    lazy var drinkName: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.textAlignment = .center
        lbl.textColor = MAIN_GREEN_COLOR
        lbl.font = UIFont(name: GILL_SANS_BOLD, size: 32)!
        lbl.adjustsFontSizeToFitWidth = true
        
        return lbl
    }()
    
    let aboutLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "About"
        lbl.textColor = MAIN_GREEN_COLOR
        lbl.font = UIFont(name: GILL_SANS_BOLD, size: 24)!
        
        return lbl
    }()
    
    lazy var aboutText: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: GILL_SANS, size: 16)!
        lbl.numberOfLines = 0
        
        return lbl
    }()
    
    let ingredientLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Ingredients"
        lbl.textColor = MAIN_GREEN_COLOR
        lbl.font = UIFont(name: GILL_SANS_BOLD, size: 24)!
        
        return lbl
    }()
    
    lazy var ingredientText: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: GILL_SANS, size: 16)!
        lbl.numberOfLines = 0
        
        return lbl
    }()
    
    let mixLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Mix"
        lbl.textColor = MAIN_GREEN_COLOR
        lbl.font = UIFont(name: GILL_SANS_BOLD, size: 24)!
        
        return lbl
    }()
    
    lazy var mixText: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: GILL_SANS, size: 16)!
        lbl.numberOfLines = 0
        
        return lbl
    }()
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        
        return scroll
    }()
    
    let contentView: UIView = {
        let view = UIView()
        
        return view
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
    
    let cellID = "cellID"
    var key: String?
    var interstitial: GADInterstitial!
    var counter: Int = 0
    let shown = "shown"
    let ref = DataService.instance.REF_DRINKS
    var ingredientHolderArray = [String]()
    var mixHolderArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-6662079405759550/5596772460")
        let request = GADRequest()
        interstitial.load(request)
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        drinksShown()
        getDrink()
    }
    
    @objc func handelZoom(tapGesture: UITapGestureRecognizer) {
        if let imageView = tapGesture.view as? UIImageView {
            preformZoomIn(imageView: imageView)
        }
    }
    
    var startingFrame: CGRect?
    let darkBackground = UIView()
    
    func preformZoomIn(imageView: UIImageView) {
        startingFrame = imageView.superview?.convert(imageView.frame, to: nil)
        let zoomImageView = UIImageView(frame: startingFrame!)
        zoomImageView.image = imageView.image
        zoomImageView.isUserInteractionEnabled = true
        zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(preformZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            darkBackground.frame = keyWindow.frame
            darkBackground.backgroundColor = UIColor(white: 0, alpha: 0.8)
            darkBackground.alpha = 0
            
            keyWindow.addSubview(darkBackground)
            keyWindow.addSubview(zoomImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                self.darkBackground.alpha = 1
                
                zoomImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomImageView.center = keyWindow.center
            }, completion: nil)
        }
    }
    
    @objc func preformZoomOut(tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.darkBackground.alpha = 0
                zoomOutImageView.frame = self.startingFrame!
                zoomOutImageView.alpha = 0
            }, completion: { (completed: Bool) in
                zoomOutImageView.removeFromSuperview()
            })
        }
    }
    
    func getDrink() {
        if let key = key {
            ref.child(key).observe(.value, with: { (snapshot) in
                
                let about = snapshot.childSnapshot(forPath: "about").value as? String
                let image = snapshot.childSnapshot(forPath: "drinkImage").value as? String
                let name = snapshot.childSnapshot(forPath: "name").value as? String
                
                if let a = about, let i = image, let n = name {
                    self.drinkName.text = n
                    self.aboutText.text = a
                    
                    let urlString = i
                    let configuration = URLSessionConfiguration.default
                    let operationQueue = OperationQueue()
                    let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
                    
                    guard let url = URL(string: urlString) else { return }
                    let downloadTask = urlSession.downloadTask(with: url)
                    downloadTask.resume()
                    
                    URLSession.shared.dataTask(with: url, completionHandler: { (data, respones, error) in
                        if error != nil {
                            print(error!)
                            return
                        }

                        let img = UIImage(data: data!)
                        DispatchQueue.main.async(execute: {
                            self.imgView.image = img
                            imageCache.setObject(img!, forKey: image! as NSString)
                        })
                    }).resume()
                }
                
                self.getDrinkIngredients(key: key)
                self.getDrinkMix(key: key)
            }, withCancel: nil)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let precentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            self.shapeLayer.strokeEnd = precentage
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    }
    
    func getDrinkIngredients(key: String) {
        ref.child(key).child("ingredients").observeSingleEvent(of: .value, with: { (ingredient) in
            if let ingredient = ingredient.children.allObjects as? [DataSnapshot] {
                for ing in ingredient {
                    let amount = ing.childSnapshot(forPath: "amount").value as? String
                    let ingredient = ing.childSnapshot(forPath: "ingredient").value as? String

                    if let amo = amount, let ing = ingredient {
                        self.ingredientHolderArray.append("\(amo) \(ing)")
                    }
                }
                self.ingredientText.text = self.ingredientHolderArray.joined(separator: "\n")
            }
        }, withCancel: nil)
    }
    
    func getDrinkMix(key: String) {
        ref.child(key).child("mix").observeSingleEvent(of: .value, with: { (mix) in
            if let mix = mix.children.allObjects as? [DataSnapshot] {
                for m in mix {
                    let how = m.childSnapshot(forPath: "how").value as? String
                    if let h = how {
                        self.mixHolderArray.append(h)
                    }
                }
                self.mixText.text = self.mixHolderArray.joined(separator: "\n")
            }
        }, withCancel: nil)
    }
    
    func startDownloadAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "one")
    }
    
    @objc func shareApplication() {
        var shareApplication = [String]()
        let text = "Great recipe on \(drinkName.text!) by HOOTCH"
        let iTunesLink = "https://itunes.apple.com/us/app/hootch-make-it-from-home/id1317524355?ls=1&mt=8"
        shareApplication = [text, iTunesLink]
        
        let activityController = UIActivityViewController(activityItems: shareApplication, applicationActivities: nil)
        
        if iPadArray.contains(UIDevice.modelName) {
            guard let popOver = activityController.popoverPresentationController else { return }
            popOver.sourceView = self.view
            present(activityController, animated: true, completion: nil)
        } else {
            present(activityController, animated: true, completion: nil)
        }
    }
    
    func setupView() {
        
        view.backgroundColor = .white
        
        let imageSize = view.frame.width / 2
        let imageSpace = imageSize / 2
        let sideMargin = view.frame.height / 20
        let margin = sideMargin / 2
        
        let placeShapeLayer = CGPoint(x: imageSpace, y: imageSpace)
        let circularPath = UIBezierPath(arcCenter: placeShapeLayer, radius: imageSpace, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        shapeLayer.path = circularPath.cgPath
        
        imgView.layer.cornerRadius = imageSpace
        
//        ScrollView Setup
        view.addSubview(scrollView)
        _ = scrollView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
//        ContentView Setup
        scrollView.addSubview(contentView)
        _ = contentView.anchor(scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: scrollView.frame.width, heightConstant: 0)
        
//        Setiup Image
        imgView.layer.addSublayer(trackLayer)
        imgView.layer.addSublayer(shapeLayer)
        contentView.addSubview(imgView)
        
//        View Content Setup
        contentView.addSubview(dismissButton)
        contentView.addSubview(shareButton)
        contentView.addSubview(drinkName)
        contentView.addSubview(aboutLabel)
        contentView.addSubview(aboutText)
        contentView.addSubview(ingredientLabel)
        contentView.addSubview(ingredientText)
        contentView.addSubview(mixLabel)
        contentView.addSubview(mixText)
        
        _ = dismissButton.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, topConstant: sideMargin, leftConstant: sideMargin, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        _ = shareButton.anchor(contentView.topAnchor, left: nil, bottom: nil, right: contentView.rightAnchor, topConstant: sideMargin, leftConstant: 0, bottomConstant: 0, rightConstant: sideMargin, widthConstant: 30, heightConstant: 30)
        _ = imgView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: sideMargin, leftConstant: imageSpace, bottomConstant: 0, rightConstant: imageSpace, widthConstant: imageSize, heightConstant: imageSize)
        _ = drinkName.anchor(imgView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: sideMargin / 2, leftConstant: sideMargin, bottomConstant: 0, rightConstant: sideMargin, widthConstant: 0, heightConstant: 0)
        _ = aboutLabel.anchor(drinkName.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: margin, leftConstant: sideMargin, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = aboutText.anchor(aboutLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: margin, leftConstant: sideMargin, bottomConstant: 0, rightConstant: sideMargin, widthConstant: 0, heightConstant: 0)
        _ = ingredientLabel.anchor(aboutText.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: margin, leftConstant: sideMargin, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = ingredientText.anchor(ingredientLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: margin, leftConstant: sideMargin, bottomConstant: 0, rightConstant: sideMargin, widthConstant: 0, heightConstant: 0)
        _ = mixLabel.anchor(ingredientText.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: margin, leftConstant: sideMargin, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = mixText.anchor(mixLabel.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: margin, leftConstant: sideMargin, bottomConstant: margin, rightConstant: sideMargin, widthConstant: 0, heightConstant: 0)
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    func drinksShown() {
        counter = UserDefaults.standard.integer(forKey: shown)
        if counter == 0 {
            if !BRONZE_USER {
                if interstitial.isReady {
                    interstitial.present(fromRootViewController: self)
                }
                counter += 1
            }
        } else if counter == 1 {
            counter += 1
        } else if counter == 2 {
            counter = 0
        }
        UserDefaults.standard.set(counter, forKey: shown)
    }
}
