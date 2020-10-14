//
//  Person.swift
//  110NamesToFaces
//
//  Created by Braic M on 05/05/2020.
//  Copyright © 2020 Braic M. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
