//
//  ItemRealm.swift
//  Todoey
//
//  Created by Thiện Đăng on 9/21/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift


@objcMembers class ItemRealm: Object {
    dynamic var title : String = ""
    dynamic var status : Bool = false
    var parentCategory = LinkingObjects(fromType: CategoryRealm.self, property:"items")
}
