//
//  IngredientBasket.swift
//  drinkassist
//
//  Created by Carl Henningsson on 8/28/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit
import Firebase

class IngredientModel: NSObject {
    let ingredient: String
    
    init(ingredient: String) {
        self.ingredient = ingredient
    }
}

@available(iOS 11.0, *)
class IngredientBasket: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let cellId = "cellId"
    var choosenIngredients = [Ingredient]()
    let userUid = UIDevice.current.identifierForVendor!.uuidString
    var basketOfIngredients: IngredientController?
    
    let blackView: UIView = {
        let bv = UIView()
        bv.alpha = 0
        bv.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        return bv
    }()
    
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.separatorStyle = .none
        tb.backgroundColor = .white
        tb.alpha = 0
        tb.allowsSelection = false
        tb.dataSource = self
        tb.delegate = self
        
        return tb
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.alpha = 0
        
        return view
    }()
    
    let containerLabelTop: UILabel = {
        let containerLbl = UILabel()
        containerLbl.text = "Ingredients"
        containerLbl.font = UIFont(name: GILL_SANS, size: 24)!
        containerLbl.textColor = PRIMARY_TEXT
        containerLbl.textAlignment = .center
        containerLbl.alpha = 0
        containerLbl.numberOfLines = 0
        
        return containerLbl
    }()
    
    let trashButton: UIButton = {
        let trashBtn = UIButton()
        trashBtn.setImage(#imageLiteral(resourceName: "trashcan"), for: .normal)
        trashBtn.alpha = 0
        
        return trashBtn
    }()
    
    lazy var ingredientController: IngredientController = {
        let ic = IngredientController()
        ic.ingredientBasket = self
        
        return ic
    }()
    
    lazy var viewController: ViewController = {
        let vc = ViewController()
        vc.ingredientAcess = self
        
        return vc
    }()
    
    @objc func deleteAllChoosenIngredients() {
        ViewController.ingredientsInBasket.removeAll()
        ViewController.ingredientBasket.setImage(UIImage(named: "harvest-empty"), for: .normal)
        handelDismiss()
    }
    
    func showIngredients() {
        if ViewController.ingredientsInBasket.count > 0 {
            if let window = UIApplication.shared.keyWindow {
                let cancelTap = UITapGestureRecognizer(target: self, action: #selector(handelDismiss))
                let margin10procent = window.frame.width / 10
                let margin5procent = window.frame.width / 20
                let topAndBottomMarginContainerView = window.frame.height / 4
                let collectionViewHeight = topAndBottomMarginContainerView * 2 - 136
                let collectionViewWidth = margin10procent * 7
                
                blackView.addGestureRecognizer(cancelTap)
                trashButton.addTarget(self, action: #selector(deleteAllChoosenIngredients), for: .touchUpInside)
                
                window.addSubview(blackView)
                window.addSubview(containerView)
                window.addSubview(tableView)
                window.addSubview(containerLabelTop)
                window.addSubview(trashButton)
                
                _ = blackView.anchor(window.topAnchor, left: window.leftAnchor, bottom: window.bottomAnchor, right: window.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
                _ = containerView.anchor(window.topAnchor, left: window.leftAnchor, bottom: window.bottomAnchor, right: window.rightAnchor, topConstant: topAndBottomMarginContainerView, leftConstant: margin10procent, bottomConstant: topAndBottomMarginContainerView, rightConstant: margin10procent, widthConstant: 0, heightConstant: 0)
                _ = containerLabelTop.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: margin5procent, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 28)
                _ = trashButton.anchor(containerView.topAnchor, left: nil, bottom: nil, right: containerView.rightAnchor, topConstant: margin5procent, leftConstant: 0, bottomConstant: 0, rightConstant: margin5procent, widthConstant: 25, heightConstant: 25)
                _ = tableView.anchor(trashButton.bottomAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: tableView.rightAnchor, topConstant: margin5procent, leftConstant: margin5procent, bottomConstant: margin5procent, rightConstant: margin5procent, widthConstant: collectionViewWidth, heightConstant: collectionViewHeight)
                
                containerView.frame = CGRect(x: 0, y: -topAndBottomMarginContainerView, width: containerView.frame.width, height: containerView.frame.height)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.blackView.alpha = 1
                    self.containerView.alpha = 1
                    
                    self.containerView.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height)
                }) { (true) in
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.containerLabelTop.alpha = 1
                        self.trashButton.alpha = 1
                        self.tableView.alpha = 1
                    }, completion: nil)
                }
            }
            tableView.reloadData()
        }
    }
    
    let okButton: UIButton = {
        let ok = UIButton()
        ok.setTitle("Ok", for: .normal)
        ok.titleLabel?.font = UIFont(name: GILL_SANS_BOLD, size: 36)!
        ok.setTitleColor(MAIN_GREEN_COLOR, for: .normal)
        ok.alpha = 0
        
        return ok
    }()
    
    func showGeneradedDrinksMessage() {
        
        if let window = UIApplication.shared.keyWindow {
            let margin10procent = window.frame.width / 10
            let margin5procent = window.frame.width / 20
            let topAndBottomMarginContainerView = window.frame.height / 4
            
            containerLabelTop.text = "You have not chosen any ingredients. One or more ingredients must be selected to generate drinks."
            containerLabelTop.font = UIFont(name: GILL_SANS, size: 16)!
            
            okButton.addTarget(self, action: #selector(handelDismissOk), for: .touchUpInside)
            
            window.addSubview(blackView)
            window.addSubview(containerView)
            window.addSubview(containerLabelTop)
            window.addSubview(okButton)
            
            _ = blackView.anchor(window.topAnchor, left: window.leftAnchor, bottom: window.bottomAnchor, right: window.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            _ = containerView.anchor(nil, left: window.leftAnchor, bottom: window.bottomAnchor, right: window.rightAnchor, topConstant: 0, leftConstant: margin10procent, bottomConstant: margin10procent, rightConstant: margin10procent, widthConstant: 0, heightConstant: topAndBottomMarginContainerView)
            _ = containerLabelTop.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: margin5procent, leftConstant: margin5procent, bottomConstant: 0, rightConstant: margin5procent, widthConstant: 0, heightConstant: 0)
            _  = okButton.anchor(nil, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: margin5procent, bottomConstant: margin5procent / 2, rightConstant: margin5procent, widthConstant: 0, heightConstant: 0)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.containerView.alpha = 1
                self.containerLabelTop.alpha = 1
                self.okButton.alpha = 1
            }, completion: nil)
        }
    }
    
    @objc func handelDismissOk() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            self.containerView.alpha = 0
            self.containerLabelTop.alpha = 0
            self.okButton.alpha = 0
            self.containerLabelTop.text = "Ingredients"
            self.containerLabelTop.font = UIFont(name: GILL_SANS, size: 24)!
        }, completion: nil)
    }
    
    @objc func handelDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            self.containerView.alpha = 0
            self.containerLabelTop.alpha = 0
            self.trashButton.alpha = 0
            self.tableView.alpha = 0
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewController.ingredientsInBasket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ingredient = ViewController.ingredientsInBasket[indexPath.item]
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? IngredientBasketCell {
            cell.setupCell(ingredient: ingredient)
            return cell
        }
        return IngredientBasketCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ViewController.ingredientsInBasket.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        if ViewController.ingredientsInBasket.isEmpty {
            ViewController.ingredientBasket.setImage(UIImage(named: "harvest-empty"), for: .normal)
            handelDismiss()
        }
    }
    
    override init() {
        super.init()
        tableView.register(IngredientBasketCell.self, forCellReuseIdentifier: cellId)
    }
}
