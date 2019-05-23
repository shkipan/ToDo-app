//
//  Item.swift
//  test
//
//  Created by Dmytro SKRYPNYK on 5/23/19.
//  Copyright © 2019 Dmytro SKRYPNYK. All rights reserved.
//

import Foundation

class Item {
    var name: String;
    var date: Date;
    
    init(name: String) {
        self.name = name;
        self.date = Date()
    }
}
