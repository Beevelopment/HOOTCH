//
//  DrinksModel.swift
//  drinkassist
//
//  Created by Carl Henningsson on 8/31/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit

class DrinkModel {
    private var _name: String!
//    private var _ingredients: String!
//    private var _mix: String!
//    private var _imageUrl: String!
    private var _postId: String!
    
    var name: String {
        return _name
    }
//    var ingredients: String{
//        return _ingredients
//    }
//    var mix: String {
//        return _mix
//    }
//    var imageUrl: String {
//        return _imageUrl
//    }
    var postId: String {
        return _postId
    }
    
    init(name: String, ingredients: String, mix: String, imageUrl: String) {
        self._name = name
//        self._ingredients = ingredients
//        self._mix = mix
//        self._imageUrl = imageUrl
    }
    
    init(postId: String, postData: Dictionary<String, AnyObject>) {
        self._postId = postId
        
        if let name = postData["name"] as? String {
            self._name = name
        }
//        if let ingredients = postData["ingredients"] as? String {
//            self._ingredients = ingredients
//        }
//        if let mix = postData["mix"] as? String {
//            self._mix = mix
//        }
//        if let imageUrl = postData["imageUrl"] as? String {
//            self._imageUrl = imageUrl
//        }
    }
}












