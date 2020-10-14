//
//  Commit+CoreDataClass.swift
//  138GithubCommits
//
//  Created by Mirko Braic on 14/05/2020.
//  Copyright © 2020 Mirko Braic. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Commit)
public class Commit: NSManagedObject {
    @objc var formattedDate: String {
        let components = Calendar.current.dateComponents([Calendar.Component.year,
                                                          Calendar.Component.month,
                                                          Calendar.Component.day],
                                                         from: date)
        return "\(components.year!)-\(components.month!)-\(components.day!)"
    }
}
