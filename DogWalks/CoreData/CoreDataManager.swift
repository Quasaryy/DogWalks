//
//  CoreDataStack.swift
//  DogWalks
//
//  Created by Yury on 07/04/2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var persistanseContainer: NSPersistentContainer = {
        let persistanseContainer = NSPersistentContainer(name: modelName)
        persistanseContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return persistanseContainer
    }()
    
    lazy var managedConext: NSManagedObjectContext = {
        let managedContext = persistanseContainer.viewContext
        
        return managedContext
    }()
    
    func save() {
        do {
            try managedConext.save()
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
}
