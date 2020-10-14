//
//  Person.swift
//  110NamesToFaces
//
//  Created by Braic M on 05/05/2020.
//  Copyright © 2020 Braic M. All rights reserved.
//

import UIKit

// it is necessary to inherit from NSObject if we want to conform to NSCoding, otherwise app will crash
class Person: NSObject, NSCoding {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }
}
