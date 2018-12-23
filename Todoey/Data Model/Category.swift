//
//  Category.swift
//  Todoey
//
//  Created by Kean Wei Wong on 23/12/2018.
//  Copyright © 2018 Kean Wei Wong. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
}
