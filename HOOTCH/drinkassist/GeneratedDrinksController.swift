//
//  GeneratedDrinksController.swift
//  drinkassist
//
//  Created by Carl Henningsson on 8/31/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit
import Firebase

class GeneratedDrinksController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerPreviewingDelegate {
    
    let ingredientLabel: UILabel = {
        let il = UILabel()
        il.textAlignment = .left
        il.text = "Ingredients:"
        il.textColor = MAIN_GREEN_COLOR
        il.font = UIFont(name: GILL_SANS, size: 24)!
        
        return il
    }()
    
    let ingredientsArray: UILabel = {
        let ia = UILabel()
        ia.textAlignment = .left
        ia.text = ""
        ia.font = UIFont(name: GILL_SANS_LIGHT, size: 16)!
        ia.textColor = SECONDARY_TEXT
        ia.numberOfLines = 0
        
        return ia
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    let cellId = "cellId"
    var choosenIngredientsArray = [String]()
    var filtredDrinksArray = [DrinkModel]()
    var drinksArray = [String]()
    var snapKey = [String]()
    var checkIfDrinkContainsIngredientArray = [String]()
    var checkDrinkLabel = ""
    let DRINKS_REF = DataService.instance.REF_DRINKS
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Drinks"

        observeFiltredDrinks(ref: DRINKS_REF)
        ingredientsArray.text = ViewController.ingredientsInBasket.joined(separator: ", ")
        
        setupViews()
        collectionView.register(DrinkCell.self, forCellWithReuseIdentifier: cellId)
        
        checkForForcedTouch()
    }
    
    private func checkForForcedTouch() {
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: collectionView)
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = collectionView.indexPathForItem(at: location) {
            let drinkRecipeController = DrinkRecipeController()
            drinkRecipeController.key = filtredDrinksArray[indexPath.item].postId
            
            return drinkRecipeController
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        present(viewControllerToCommit, animated: true, completion: nil)
    }
    
    func observeFiltredDrinks(ref: DatabaseReference) {
        ref.observe(.value, with: { (snapshot) in
            self.filtredDrinksArray = []
            self.checkIfDrinkContainsIngredientArray = []
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    self.DRINKS_REF.child(snap.key).child("ingredients").observeSingleEvent(of: .value, with: { (ingredientSnap) in
                        if let ingredientSnap = ingredientSnap.children.allObjects as? [DataSnapshot] {
                            for ingSnap in ingredientSnap {
                                if let ingredient = ingSnap.childSnapshot(forPath: "ingredient").value as? String {
                                    self.checkIfDrinkContainsIngredientArray.append(ingredient)
//                                    self.snapKey.append(snap.key)
                                }
                            }
                            self.checkDrinkLabel = self.checkIfDrinkContainsIngredientArray.joined()
                            var counter = 0
                            
                            for x in ViewController.ingredientsInBasket {
                                if self.checkIfDrinkContainsIngredientArray.contains(x) {
                                    counter += 1
                                }
                            }
                            
                            if counter == ViewController.ingredientsInBasket.count {
                                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                        let key = snap.key
                                        let drinkName = DrinkModel(postId: key, postData: postDict)
                                        self.filtredDrinksArray.append(drinkName)
                                    }
                                counter = 0
                            }
                            self.checkIfDrinkContainsIngredientArray = []
                        }
                        activityIndicator.stopAnimating()
                        self.collectionView.reloadData()
                    }, withCancel: nil)
                }
            }
            if self.filtredDrinksArray.isEmpty {
                emptyArrayMessage.isHidden = false
            } else {
                emptyArrayMessage.isHidden = true
            }
        }, withCancel: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filtredDrinksArray.count > 0 {
            emptyArrayMessage.isHidden = true
        }
        return filtredDrinksArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let drinks = filtredDrinksArray[indexPath.item]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? DrinkCell {
            cell.setupCell(model: drinks)
            
            return cell
        }
        return DrinkCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let drinkRecipeController = DrinkRecipeController()
        let drink = filtredDrinksArray[indexPath.item]
        
        drinkRecipeController.key = drink.postId
        present(drinkRecipeController, animated: true, completion: nil)
    }
    
    func setupViews() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        activityIndicator.startAnimating()
        
//        Margins
        let margin5procent = view.frame.width / 20
        let margin10procent = margin5procent * 2
        
//        Elements Added To View
        view.addSubview(ingredientLabel)
        view.addSubview(ingredientsArray)
        view.addSubview(collectionView)
        view.addSubview(emptyArrayMessage)
        
//        Elements Constraints
        _ = ingredientLabel.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: margin10procent, leftConstant: margin10procent, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = ingredientsArray.anchor(ingredientLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: margin5procent, leftConstant: margin10procent, bottomConstant: 0, rightConstant: margin10procent, widthConstant: 0, heightConstant: 0)
        _ = collectionView.anchor(ingredientsArray.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: margin10procent, leftConstant: margin10procent, bottomConstant: margin5procent, rightConstant: margin10procent, widthConstant: 0, heightConstant: 0)
        _ = emptyArrayMessage.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: margin10procent, bottomConstant: margin5procent, rightConstant: margin10procent, widthConstant: 0, heightConstant: 0)
    }
}
























