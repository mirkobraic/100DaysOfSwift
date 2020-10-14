//
//  CoreDataManager.swift
//  138GithubCommits
//
//  Created by Mirko Braic on 29/05/2020.
//  Copyright © 2020 Mirko Braic. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Project38")
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                // something has gone fatally wrong
                print("Unresolved error: \(error)")
            }
        }
        return container
    }()
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occured while saving: \(error)")
            }
        }
    }
    
    func create<T: NSManagedObject>(_ type: T.Type) -> T {
        return T(context: container.viewContext)
    }
    
    func fetch<T: NSFetchRequestResult>(_ request: NSFetchRequest<T>) throws -> [T] {
        return try container.viewContext.fetch(request)
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
}
