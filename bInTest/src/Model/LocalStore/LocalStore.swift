//
//  LocalStore.swift
//  bInTest
//
//  Created by Sergey Minakov on 01.06.16.
//  Copyright © 2016 Naithar. All rights reserved.
//

import CoreData

class LocalStore {
    
    static let instance = LocalStore()
    
    private(set) var context: NSManagedObjectContext
    
    init() {
        guard let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension:"momd"),
            let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
                fatalError("Error initializing mom")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        self.context.persistentStoreCoordinator = psc
        
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let docURL = urls[urls.endIndex-1]
        
        let storeURL = docURL.URLByAppendingPathComponent("DataModel.sqlite")
        do {
            try psc.addPersistentStoreWithType(NSSQLiteStoreType,
                                               configuration: nil,
                                               URL: storeURL,
                                               options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }
    
    final func contains(photoId photoId: String, serverId: String, secret: String, farmId: Int64) -> Bool {
        
        let request = NSFetchRequest(entityName: "MapItem")
        let predicateFormat = "photoId == %@ AND serverId == %@ AND secret == %@ AND farmId == %@"
        request.predicate = NSPredicate(format: predicateFormat, photoId, serverId, secret, "\(farmId)")
        
        var error: NSError? = nil
        let count = self.context.countForFetchRequest(request, error: &error)
        return count != 0
    }
    
    var count: Int {
        let request = NSFetchRequest(entityName: "MapItem")
        var error: NSError? = nil
        let count = self.context.countForFetchRequest(request, error: &error)
        return count
    }
}