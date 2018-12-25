//
//  CategoryModel.swift
//  drinkassist
//
//  Created by Carl Henningsson on 10/7/18.
//  Copyright © 2018 Henningsson Company. All rights reserved.
//

import Foundation

class ChoiceModel: NSObject {
    let image: String
    let label: String
    
    init(image: String, label: String) {
        self.image = image
        self.label = label
    }
}
