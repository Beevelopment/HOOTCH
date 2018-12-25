//
//  SettingsModel.swift
//  drinkassist
//
//  Created by Carl Henningsson on 10/14/18.
//  Copyright © 2018 Henningsson Company. All rights reserved.
//

import Foundation

class SettingsModel: NSObject {
    let image: String
    let titel: String
    
    init(image: String, titel: String) {
        self.image = image
        self.titel = titel
    }
}
