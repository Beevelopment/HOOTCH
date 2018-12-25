//
//  AboutController.swift
//  drinkassist
//
//  Created by Carl Henningsson on 9/2/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit

class AboutController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let dismissButton: UIButton = {
        let dismissBtn = UIButton(type: .system)
        dismissBtn.setImage(UIImage(named: "closeBtn"), for: .normal)
        dismissBtn.tintColor = .white
        dismissBtn.addTarget(self, action: #selector(dismissFunc), for: .touchUpInside)
        
        return dismissBtn
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "About"
        lbl.textColor = .white
        lbl.font = UIFont(name: GILL_SANS_SEMIBOLD, size: 36)!
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = MAIN_GREEN_COLOR
        cv.showsVerticalScrollIndicator = false
        
        return cv
    }()
    
    var viewController: ViewController?
    let cellId = "cellId"
    
    let about: [AboutModel] = {
        let termsOfUse = AboutModel(title: "Terms of use", text: "By using HOOTCH you are agreeing to our terms of use. The application uses Firebase as its database and for monetizing the users behavior when application is in use. Therefore we encourage you to read their terms of use. You find a link below. For the application to work properly we are using your phones specific id. This is only used to store the ingredients you are choosing for the drink. The application is for those who are 18 years old or older. We do not take responsibility for the users under the age limit. And for privacy reasons we can’t check how old the user is. For advertising we use AdMob and for the privacy details read AdMobs terms, link below.")
        let thisApp = AboutModel(title: "This App", text: "HOOTCH is the application you need for every Friday night! How to use this app is extremely simple. Start of by selecting which category you want to search and choose the ingredient. When you are done go back to the main screen and press the button “generate drinks”. Last of press on the drink you desire. Simple as that! Do you want an more detailed tutorial, press the link below.")
        let pricing = AboutModel(title: "Pricing", text: "Bronze: 10 SEK\nGOLD: 30 SEK\nPLATINUM: 50 SEK")
        
        var aboutArray = [termsOfUse, thisApp, pricing]
        
        return aboutArray
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return about.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let about = self.about[indexPath.item]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? AboutCell {
            cell.about = about
            
            return cell
        }
        return AboutCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let cell = about[indexPath.item].text
            let height = 60
            var estimatedHeight = 0
            estimatedHeight = Int(estimateFrameForText(cell).height + view.frame.width / 10 * 2 + 10)
        
            print("Carl: estemeded height \(estimatedHeight)")
            if estimatedHeight > height {
                return CGSize(width: collectionView.frame.width, height: CGFloat(estimatedHeight))
            }
        
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    @objc func dismissFunc() {
        dismiss(animated: true, completion: nil)
    }
    
    func placeElements() {
//        Margin
        let margin5procent = view.frame.width / 20
        let margin10procent = margin5procent * 2
        let margin15procent = margin5procent * 3
        
//        Add Elements to view
        view.addSubview(dismissButton)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        
//        Add constraints
        _ = dismissButton.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: margin5procent, leftConstant: margin5procent, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        _ = titleLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: margin15procent, leftConstant: margin10procent, bottomConstant: 0, rightConstant: margin10procent, widthConstant: 0, heightConstant: 0)
        _ = collectionView.anchor(titleLabel.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: margin5procent, leftConstant: margin10procent, bottomConstant: margin5procent, rightConstant: margin10procent, widthConstant: 0, heightConstant: 0)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MAIN_GREEN_COLOR
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(AboutCell.self, forCellWithReuseIdentifier: cellId)
        
        placeElements()
    }
    
    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: collectionView.frame.width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont(name: GILL_SANS, size: 16)!], context: nil)
    }
    
}
