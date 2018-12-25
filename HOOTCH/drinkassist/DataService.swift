//
//  DataService.swift
//  drinkassist
//
//  Created by Carl Henningsson on 8/26/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_DRINKS = DB_BASE.child("drinks")
    private var _REF_INGREDIENTS = DB_BASE.child("ingredients")
    private var _REF_USER = DB_BASE.child("user")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    var REF_DRINKS: DatabaseReference {
        return _REF_DRINKS
    }
    var REF_INGREDIENTS: DatabaseReference {
        return _REF_INGREDIENTS
    }
    var REF_USER: DatabaseReference {
        return _REF_USER
    }
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
        REF_USER.child(uid).updateChildValues(user)
    }
}




















