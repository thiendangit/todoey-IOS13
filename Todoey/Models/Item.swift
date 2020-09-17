//
//  Item.swift
//  Todoey
//
//  Created by Thiện Đăng on 9/17/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

class Item : Codable {
    var title : String?
    var status : Bool?
    
    init(title : String? , status : Bool?) {
        self.title = title
        self.status = status
    }
}
