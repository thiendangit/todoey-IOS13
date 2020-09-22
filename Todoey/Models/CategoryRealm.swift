//
//  CategoryRealm.swift
//  Todoey
//
//  Created by Thiện Đăng on 9/21/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift


@objcMembers class CategoryRealm: Object {
    dynamic var  name : String = ""
    let items = List<ItemRealm>()
}
