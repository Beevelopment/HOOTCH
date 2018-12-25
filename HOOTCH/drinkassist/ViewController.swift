//
//  ViewController.swift
//  drinkassist
//
//  Created by Carl Henningsson on 8/26/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    static var ingredientBasket: UIButton = {
        let basket = UIButton(type: .system)
        basket.setImage(UIImage(named: "harvest-empty"), for: .normal)
        basket.widthAnchor.constraint(equalToConstant: 25).isActive = true
        basket.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        return basket
    }()
    
    let settingsButton: UIButton = {
        let settingsBtn = UIButton(type: .system)
        settingsBtn.setImage(UIImage(named: "menu"), for: .normal)
        settingsBtn.widthAnchor.constraint(equalToConstant: 25).isActive = true
        settingsBtn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        return settingsBtn
    }()
    
    lazy var collectionView: UICollectionView = {
        let cellSize = view.frame.width / 10 * 7 / 3
        let space = cellSize / 4
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = space
        layout.sectionInset.top = cellSize / 2
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .white
        
        return cv
    }()

    let generateDrinksButton: UIButton = {
        let generateDrinksBtn = UIButton()
        generateDrinksBtn.setTitle("Generate Drinks", for: .normal)
        generateDrinksBtn.setTitleColor(PRIMARY_TEXT, for: .normal)
        generateDrinksBtn.titleLabel!.font = UIFont(name: GILL_SANS, size: 20)!
        generateDrinksBtn.backgroundColor = MAIN_GREEN_COLOR
        generateDrinksBtn.layer.cornerRadius = 10
        generateDrinksBtn.addTarget(self, action: #selector(generateDrinks), for: .touchUpInside)
        generateDrinksBtn.layer.shadowColor = UIColor(white: 0, alpha: 1).cgColor
        generateDrinksBtn.layer.shadowOpacity = 0.3
        generateDrinksBtn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        generateDrinksBtn.layer.shadowRadius = 2.0
        
        return generateDrinksBtn
    }()
    
    lazy var ingredientController: IngredientController = {
        let launcher = IngredientController()
        launcher.viewController = self
        return launcher
    }()
    
    let ingredientBasketView = IngredientBasket()
    let settingsLancher = SettingsLancher()
    let userUid = UIDevice.current.identifierForVendor!.uuidString
    var settingAcess: SettingsLancher?
    var ingredientAcess: IngredientBasket?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let cellID = "cellID"
    static var ingredientsInBasket = [String]()
    
    let choices: [ChoiceModel] = {
        let ingredients = ChoiceModel(image: "bottle", label: "Ingredients")
        let drinks = ChoiceModel(image: "icon", label: "Drinks")
        let random = ChoiceModel(image: "dices", label: "Surprise")
        
        var choiceArray = [ingredients, drinks, random]
       
        return choiceArray
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
//        setupAds()
        
        DataService.instance.REF_USER.child("\(userUid)").child("choosen").removeValue()
        
        placeElementsOnView(bannerView)
        
        if !fistTimeUser {
            present(GuideController(), animated: true, completion: nil)
        }
        
        collectionView.register(ChoiceCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return choices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = choices[indexPath.item]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? ChoiceCell {
            cell.choice = category
            return cell
        } else {
            return ChoiceCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item != 2 {
            let ingredientController = IngredientController()
            let title = choices[indexPath.item].label
            ingredientController.title = title
            navigationController?.pushViewController(ingredientController, animated: true)
        } else {
            addAllKeys()
            settingsLancher.animateDice()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if iPadArray.contains(UIDevice.modelName) {
            let width = view.frame.width / 20 * 16
            let height = width / 6
            
            return CGSize(width: width, height: height)
        } else {
            let width = view.frame.width / 20 * 18
            let height = width / 3
            
            return CGSize(width: width, height: height)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            flowLayout.sectionInset.top = flowLayout.itemSize.height / 2
        } else {
            let cellSize = view.frame.width / 10 * 7 / 3
            flowLayout.sectionInset.top = cellSize / 2
        }
        
        flowLayout.invalidateLayout()
    }
    
    static var allKeys = [String]()
    
    func addAllKeys() {
        DataService.instance.REF_DRINKS.observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            ViewController.allKeys = []
            for snap in snapshot {
                let key = snap.key
                ViewController.allKeys.append(key)
            }
            self.settingsLancher.stopAnimateDice()
        }
    }
    
    func randomizer() {
        let randomKey = String(arc4random_uniform(UInt32(ViewController.allKeys.count)))
        let drinkRecipieController = DrinkRecipeController()
        drinkRecipieController.key = randomKey
        
        appDelegate.window?.rootViewController!.present(drinkRecipieController, animated: true, completion: nil)
    }
    
    func showGuideController() {
        let guideController = GuideController()
        appDelegate.window?.rootViewController!.present(guideController, animated: true, completion: nil)
    }
    
    func shareApplication() {
        var shareApplication = [String]()
        let text = "Get your party on with HOOTCH"
        let iTunesLink = "https://itunes.apple.com/us/app/hootch-make-it-from-home/id1317524355?ls=1&mt=8"
        shareApplication = [text, iTunesLink]
        
        let activityController = UIActivityViewController(activityItems: shareApplication, applicationActivities: nil)
        
        if iPadArray.contains(UIDevice.modelName) {
            guard let popOver = activityController.popoverPresentationController else { return }
            popOver.sourceView = self.view
            appDelegate.window?.rootViewController!.present(activityController, animated: true, completion: nil)
        } else {
            appDelegate.window?.rootViewController!.present(activityController, animated: true, completion: nil)
        }
    }
    
    @objc func handleMore() {
        ingredientBasketView.showIngredients()
    }
    
    @objc func toggleSetting() {
        settingsLancher.showSettings()
    }
    
    func setupAds() {
        if !BRONZE_USER {
            bannerView.adUnitID = "ca-app-pub-6662079405759550/6100115590"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
    }
    
    func restorePurchase() {
        PurchaseManaager.instance.restoreCompletedPurchases { success in
            if success {
                bannerView.removeFromSuperview()
            }
        }
    }
    
    @objc func generateDrinks() {
        let generatedDrinksController = GeneratedDrinksController()
        
        if ViewController.ingredientsInBasket.isEmpty {
            ViewController.ingredientBasket.setImage(UIImage(named: "harvest-empty"), for: .normal)
            ingredientBasketView.showGeneradedDrinksMessage()
        } else {
            self.navigationController?.pushViewController(generatedDrinksController, animated: true)
        }
    }
    
    func placeElementsOnView(_ bannerView: GADBannerView) {
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.title = "HOOTCH"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: MAIN_GREEN_COLOR, NSAttributedStringKey.font: UIFont(name: "GillSans-Bold", size: 28)!]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = MAIN_GREEN_COLOR
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: settingsButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: ViewController.ingredientBasket)
        
        settingsButton.addTarget(self, action: #selector(toggleSetting), for: .touchUpInside)
        ViewController.ingredientBasket.addTarget(self, action: #selector(handleMore), for: .touchUpInside)
        
        let sideMargin = view.frame.width / 20

        view.addSubview(collectionView)
        view.addSubview(generateDrinksButton)
        view.addSubview(bannerView)
    
        _ = collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: generateDrinksButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = generateDrinksButton.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: sideMargin, bottomConstant: sideMargin + 50, rightConstant: sideMargin, widthConstant: 0, heightConstant: 40)
        _ = bannerView.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
    }
}
