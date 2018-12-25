//
//  File.swift
//  drinkassist
//
//  Created by Carl Henningsson on 9/3/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit
import Foundation

class AboutModel: NSObject {
    
    private var _title: String!
    private var _text: String!
    
    var title: String {
        return _title
    }
    var text: String {
        return _text
    }
    
    init(title: String, text: String) {
        self._title = title
        self._text = text
    }
}
