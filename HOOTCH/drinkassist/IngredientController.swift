//
//  IngredientController.swift
//  drinkassist
//
//  Created by Carl Henningsson on 8/26/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit
import Firebase

class IngredientController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIViewControllerPreviewingDelegate {
    
    let cellId = "cellId"
    
    let searchTextField: UITextView = {
        let stf = UITextView()
        stf.layer.cornerRadius = 5
        stf.backgroundColor = SEARCH_COLOR
        stf.layer.zPosition = 0
        stf.font = UIFont(name: GILL_SANS, size: 16)!
        stf.textContainerInset.top = 5
        stf.textContainerInset.left = 10
        stf.textContainerInset.right = 40
        stf.textColor = HINT_TEXT
        stf.textContainer.maximumNumberOfLines = 1
        stf.isScrollEnabled = false
        
        return stf
    }()
    
    let searchIcon: UIImageView = {
        let search = UIImageView()
        search.image = UIImage(named: "searchicon")
        search.layer.zPosition = 1
        
        return search
    }()
    
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.separatorStyle = .none
        tb.allowsSelection = true
        tb.dataSource = self
        tb.delegate = self
        
        return tb
    }()
    
    let textViewIsEdited: UIView = {
        let view = UIView()
        
        return view
    }()
    
    lazy var basketIngredient: IngredientBasket = {
        let ib = IngredientBasket()
        ib.basketOfIngredients = self
        
        return ib
    }()
    
    var ingredients = [Ingredient]()
    var filteredArray = [String]()
    var filteredArrayKey = [String]()
    var viewController: ViewController?
    var ingredientBasket: IngredientBasket?
    let BASE_REF = DataService.instance.REF_BASE
    let userUid = UIDevice.current.identifierForVendor!.uuidString
    
    override func viewDidAppear(_ animated: Bool) {
        searchTextField.text = "Search for \(title!)"
        tableView.reloadData()
    }

    override func viewDidLoad() {
        activityIndicator.transform = CGAffineTransform(scaleX: 1, y: 1)
        super.viewDidLoad()
        getIngredients()
        searchTextField.delegate = self
        
        view.backgroundColor = .white
        textViewIsEdited.isHidden = true
        
        placeElements()
        
        tableView.register(IngredientCell.self, forCellReuseIdentifier: cellId)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSelectionOnTextView))
        textViewIsEdited.addGestureRecognizer(tap)
        
        checkForForcedTouch()
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if parent == nil {
            self.searchTextField.text = "Search for \(title!)"
            self.searchTextField.textColor = HINT_TEXT
            self.filteredArray = []
            self.filteredArrayKey = []
            self.ingredients = []
        }
    }
    
    private func checkForForcedTouch() {
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: tableView)
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if title!.lowercased() == "drinks" {
            if let indexPath = tableView.indexPathForRow(at: location) {
                let drinkRecipeController = DrinkRecipeController()
                
                if searchTextField.text == "" || searchTextField.text == "Search for \(title!)" {
                    drinkRecipeController.key = ingredients[indexPath.row].POST_ID
                } else {
                    drinkRecipeController.key = filteredArrayKey[indexPath.row]
                }
                
                return drinkRecipeController
            }
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        present(viewControllerToCommit, animated: true, completion: nil)
    }
    
    func getIngredients() {
        if let firebasePath = title?.lowercased() {
            observeIngredients(ref: BASE_REF.child(firebasePath))
        }
    }
    
    @objc func dismissSelectionOnTextView() {
        view.endEditing(true)
        textViewIsEdited.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if searchTextField.text.count == 0 || searchTextField.text == "Search for \(title!)" {
            self.filteredArray = []
            getIngredients()
            self.tableView.reloadData()
        } else {
            textViewIsEdited.isHidden = false
            if let firebasePath = title?.lowercased() {
                getIngredients(forSearchQuery: searchTextField.text.lowercased(), ref: BASE_REF.child(firebasePath), handler: { (returnedFilteredArray) in
                    self.filteredArray = returnedFilteredArray
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if searchTextField.textColor == HINT_TEXT {
            searchTextField.text = ""
            searchTextField.textColor = PRIMARY_TEXT
            textViewIsEdited.isHidden = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if searchTextField.text.isEmpty {
            searchTextField.textColor = HINT_TEXT
            searchTextField.text = "Search for \(title!)"
        }
    }
    
    func observeIngredients(ref: DatabaseReference) {
        if let firebasePath = title?.lowercased() {
            ref.observe(.value, with: { (snapshot) in
                self.ingredients = []
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in snapshot {
                        if firebasePath == "ingredients" {
                            if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                let key = snap.key
                                let ingredient = Ingredient(postId: key, what: firebasePath, postData: postDict)
                                self.ingredients.append(ingredient)
                            }
                        } else {
                            let path = "name"
                            let drinkName = snap.childSnapshot(forPath: path).value as AnyObject
                            let postDict: Dictionary<String, AnyObject> = [path: drinkName]
                            let key = snap.key
                            let drink = Ingredient(postId: key, what: path, postData: postDict)
                            self.ingredients.append(drink)
                        }
                    }
                }
                activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }, withCancel: nil)
        }
    }
    
    func getIngredients(forSearchQuery query: String, ref: DatabaseReference, handler: @escaping (_ filteredArray: [String]) -> ()) {
        if let firebasePath = title?.lowercased() {
            ref.observe(.value, with: { (snapshot) in
                self.filteredArray = []
                self.filteredArrayKey = []
                guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
                for snap in snapshot {
                    if firebasePath == "ingredients" {
                        guard let ingredient = snap.childSnapshot(forPath: firebasePath).value as? String else { return }
                        let key = snap.key
                        let ing = ingredient.lowercased()
                        if ing.contains(query) {
                            self.filteredArray.append(ingredient)
                            self.filteredArrayKey.append(key)
                        }
                    } else {
                        guard let drink = snap.childSnapshot(forPath: "name").value as? String else { return }
                        let key = snap.key
                        let dri = drink.lowercased()
                        if dri.contains(query) {
                            self.filteredArray.append(drink)
                            self.filteredArrayKey.append(key)
                        }
                    }
                }
                handler(self.filteredArray)
            }, withCancel: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentReachabilityStatus != .notReachable {
            if searchTextField.text == "" || searchTextField.text == "Search for \(title!)" {
                emptyArrayMessage.isHidden = true
                return ingredients.count
            } else {
                emptyArrayMessage.isHidden = true
                return filteredArray.count
            }
        } else {
            activityIndicator.stopAnimating()
            emptyArrayMessage.text = "No internet, please check your internet connection and try again."
            emptyArrayMessage.isHidden = false
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ingredient = ingredients[indexPath.row]
        
        if filteredArray.isEmpty {
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? IngredientCell {
                if ViewController.ingredientsInBasket.contains(ingredient.INGREDIENT) {
                    cell.configureIngredientCell(lable: ingredient, isSelected: true)
                } else {
                    cell.configureIngredientCell(lable: ingredient, isSelected: false)
                }
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? IngredientCell {
                let filtredIngredients = filteredArray[indexPath.row]
                
                if ViewController.ingredientsInBasket.contains(filtredIngredients) {
                    cell.configureFiltredIngredients(lable: filtredIngredients, isSelected: true, postId: ingredient.POST_ID)
                } else {
                    cell.configureFiltredIngredients(lable: filtredIngredients, isSelected: false, postId: ingredient.POST_ID)
                }
                return cell
            }
        }
        return IngredientCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let firebasePath = title?.lowercased(), firebasePath == "ingredients" {
        guard let cell = tableView.cellForRow(at: indexPath) as? IngredientCell else { return }
            if let text = cell.ingredientLable.text {
                if !ViewController.ingredientsInBasket.contains(text) {
                    ViewController.ingredientsInBasket.append(text)
                    ViewController.ingredientBasket.setImage(UIImage(named: "harvest"), for: .normal)
                } else {
                    ViewController.ingredientsInBasket = ViewController.ingredientsInBasket.filter({ $0 != text })
                    if ViewController.ingredientsInBasket.count < 1 {
                        ViewController.ingredientBasket.setImage(UIImage(named: "harvest-empty"), for: .normal)
                    }
                }
            }
            self.tableView.reloadRows(at: [indexPath], with: .none)
        } else {
            showDrinkFromRow(indexPath: indexPath)
        }
    }
    
    func showDrinkFromRow(indexPath: IndexPath) {
        let drinkRecipieController = DrinkRecipeController()
        let drinkKey: String?
        if searchTextField.text == "" || searchTextField.text == "Search for \(title!)" {
            drinkKey = ingredients[indexPath.row].POST_ID
        } else {
            drinkKey = filteredArrayKey[indexPath.row]
        }
        guard let key = drinkKey else { return }
        drinkRecipieController.key = key
        present(drinkRecipieController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func placeElements() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        activityIndicator.startAnimating()
        
//        Margins
        let margin5procent = view.frame.width / 20
        let margin10procent = margin5procent * 2
        
//          Elements Added To View
        view.addSubview(searchIcon)
        view.addSubview(searchTextField)
        view.addSubview(tableView)
        view.addSubview(textViewIsEdited)
        view.addSubview(emptyArrayMessage)
        
//        Elements Constraints
        if iPadArray.contains(deviceModel) {
            _ = searchTextField.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: margin5procent, leftConstant: margin5procent, bottomConstant: 0, rightConstant: margin5procent, widthConstant: 0, heightConstant: margin10procent)
        } else {
            _ = searchTextField.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: margin10procent, leftConstant: margin5procent, bottomConstant: 0, rightConstant: margin5procent, widthConstant: 0, heightConstant: margin10procent)
        }
        _ = tableView.anchor(searchTextField.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: margin5procent, leftConstant: margin5procent, bottomConstant: margin10procent, rightConstant: margin5procent, widthConstant: 0, heightConstant: 0)
        _ = searchIcon.anchor(searchTextField.topAnchor, left: nil, bottom: searchTextField.bottomAnchor, right: searchTextField.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 5, rightConstant: 10, widthConstant: 20, heightConstant: 20)
        _ = textViewIsEdited.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = emptyArrayMessage.anchor(searchTextField.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: margin10procent, bottomConstant: 0, rightConstant: margin10procent, widthConstant: 0, heightConstant: 0)
    }
}
