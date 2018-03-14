//
//  Categories.swift
//  Todoey
//
//  Created by Roman on 11/03/2018.
//  Copyright © 2018 RJD. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    @objc dynamic var name: String = ""
   var items = List<Item>()
    
}
