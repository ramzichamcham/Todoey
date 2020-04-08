//
//  Category.swift
//  Todoey
//
//  Created by Ramzi chamcham on 2020-04-06.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
