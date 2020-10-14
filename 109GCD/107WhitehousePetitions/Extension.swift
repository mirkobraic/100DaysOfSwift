//
//  Extension.swift
//  107WhitehousePetitions
//
//  Created by Mirko Braic on 21/04/2020.
//  Copyright © 2020 Mirko Braic. All rights reserved.
//

import Foundation

extension String {
    func htmlDecoded() -> String {
        let decoded = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ], documentAttributes: nil).string

        return decoded ?? self
    }
}
