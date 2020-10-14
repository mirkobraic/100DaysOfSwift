//
//  Petition.swift
//  107WhitehousePetitions
//
//  Created by Mirko Braic on 21/04/2020.
//  Copyright © 2020 Mirko Braic. All rights reserved.
//

import Foundation

struct Petition: Codable {
    let title: String
    let body: String
    let signatureCount: Int
}
