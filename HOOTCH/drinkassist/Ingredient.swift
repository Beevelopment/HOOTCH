//
//  Ingredient.swift
//  drinkassist
//
//  Created by Carl Henningsson on 8/26/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit

class Ingredient {
    
    private var _INGREDIENT: String!
    private var _POST_ID: String!
    
    var INGREDIENT: String {
        return _INGREDIENT
    }
    var POST_ID: String {
        return _POST_ID
    }
    
    init(ingredient: String) {
        self._INGREDIENT = ingredient
    }
    
    init(postId: String, what: String, postData: Dictionary<String, AnyObject>) {
        self._POST_ID = postId
        
        if let INGREDIENT = postData[what] as? String {
            self._INGREDIENT = INGREDIENT
        }
    }
}


