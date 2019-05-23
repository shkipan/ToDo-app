//
//  Item.swift
//  test
//
//  Created by Dmytro SKRYPNYK on 5/23/19.
//  Copyright © 2019 Dmytro SKRYPNYK. All rights reserved.
//

import Foundation

class Item: NSObject, NSCoding {
    var name: String;
    var date: Date;
    
    static let Dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let ArchiveURL = Dir.appendingPathComponent("items")
    
    init(name: String) {
        self.name = name;
        self.date = Date()
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        self.init(name: name)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(date, forKey: "date")
    }
}
