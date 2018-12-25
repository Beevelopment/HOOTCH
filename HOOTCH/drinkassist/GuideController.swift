//
//  GuideController.swift
//  drinkassist
//
//  Created by Carl Henningsson on 9/3/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit

class GuideController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        
        return cv
    }()
    
    let cellID = "cellID"
    var viewController: ViewController?
    
    let iPadGuides: [GuideModel] = {
        let firstPage = GuideModel(title: "Welcome", message: "Let´s get your party on", imageName: "onePad")
        let secondPage = GuideModel(title: "Ingredients", message: "Search and choose the ingredients you have available", imageName: "twoPad")
        let thirdPage = GuideModel(title: "Drinks", message: "Choose a drink based on your ingredients", imageName: "threePad")
        let fourthPage = GuideModel(title: "Recipe", message: "Detailed recipe for the chosen drink", imageName: "fourPad")
        
        var pageArray = [firstPage, secondPage, thirdPage, fourthPage]
        
        return pageArray
    }()
    
    let iPhoneEightGuides: [GuideModel] = {
        let firstPage = GuideModel(title: "Welcome", message: "Let´s get your party on", imageName: "one8")
        let secondPage = GuideModel(title: "Ingredients", message: "Search and choose the ingredients you have available", imageName: "two8")
        let thirdPage = GuideModel(title: "Drinks", message: "Choose a drink based on your ingredients", imageName: "three8")
        let fourthPage = GuideModel(title: "Recipe", message: "Detailed recipe for the chosen drink", imageName: "four8")
        
        var pageArray = [firstPage, secondPage, thirdPage, fourthPage]
        
        return pageArray
    }()
    
    let iPhoneXGuides: [GuideModel] = {
        let firstPage = GuideModel(title: "Welcome", message: "Let´s get your party on", imageName: "oneX")
        let secondPage = GuideModel(title: "Ingredients", message: "Search and choose the ingredients you have available", imageName: "twoX")
        let thirdPage = GuideModel(title: "Drinks", message: "Choose a drink based on your ingredients", imageName: "threeX")
        let fourthPage = GuideModel(title: "Recipe", message: "Detailed recipe for the chosen drink", imageName: "fourX")
        
        var pageArray = [firstPage, secondPage, thirdPage, fourthPage]
        
        return pageArray
    }()
    
    lazy var pageController: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = MAIN_GREEN_COLOR
        pc.pageIndicatorTintColor = DIVIDERS
        pc.numberOfPages = self.iPadGuides.count
        
        return pc
    }()
    
    lazy var nextButton: UIButton = {
        let nextBtn = UIButton()
        nextBtn.setTitle("Next", for: .normal)
        nextBtn.setTitleColor(MAIN_GREEN_COLOR, for: .normal)
        nextBtn.titleLabel?.font = UIFont(name: GILL_SANS, size: 16)!
        nextBtn.alpha = 1
        nextBtn.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        
        return nextBtn
    }()
    
    lazy var doneButton: UIButton = {
        let doneBtn = UIButton()
        doneBtn.setTitle("Done", for: .normal)
        doneBtn.setTitleColor(MAIN_GREEN_COLOR, for: .normal)
        doneBtn.titleLabel?.font = UIFont(name: GILL_SANS, size: 16)!
        doneBtn.alpha = 0
        doneBtn.addTarget(self, action: #selector(dismissGuideController), for: .touchUpInside)
        
        return doneBtn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GuideCell.self, forCellWithReuseIdentifier: cellID)
        
        placeElementsOnView()
    }
    
    @objc func dismissGuideController() {
        if !fistTimeUser {
            UserDefaults.standard.set(true, forKey: UID)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func nextPage() {
        if pageController.currentPage == iPadGuides.count - 2 {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.nextButton.alpha = 0
                self.doneButton.alpha = 1
            }, completion: nil)
        }
        
        let indexPath = IndexPath(item: pageController.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageController.currentPage += 1
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageController.currentPage = pageNumber
        
        if pageNumber == (iPadGuides.count - 1) {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.nextButton.alpha = 0
                self.doneButton.alpha = 1
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.doneButton.alpha = 0
                self.nextButton.alpha = 1
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iPadGuides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if iPadArray.contains(deviceModel) {
            let pages = iPadGuides[indexPath.item]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? GuideCell else { return GuideCell() }
            cell.page = pages
            return cell
        } else if iPhoneEight.contains(deviceModel) {
            let pages = iPhoneEightGuides[indexPath.item]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? GuideCell else { return GuideCell() }
            cell.page = pages
            return cell
        } else {
            let pages = iPhoneXGuides[indexPath.item]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? GuideCell else { return GuideCell() }
            cell.page = pages
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func placeElementsOnView() {
//        margin
        let margin5procent = view.frame.width / 20
        
//        Add objects to view
        view.addSubview(collectionView)
        view.addSubview(pageController)
        view.addSubview(nextButton)
        view.addSubview(doneButton)
        
//        add constrains
        _ = collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = pageController.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: margin5procent, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = nextButton.anchor(pageController.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: margin5procent, widthConstant: 0, heightConstant: 0)
        _ = doneButton.anchor(pageController.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: margin5procent, widthConstant: 0, heightConstant: 0)
    }
}
