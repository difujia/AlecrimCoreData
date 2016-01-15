//
//  Table.swift
//  AlecrimCoreData
//
//  Created by Vanderlei Martinelli on 2014-06-25.
//  Copyright (c) 2014, 2015 Alecrim. All rights reserved.
//

import Foundation
import CoreData

private typealias HashableDuplet = Duplet<String, NSManagedObjectContext>
private var cachedEntityDescriptions = [HashableDuplet : NSEntityDescription ]()

public struct Table<T: NSManagedObject>: TableType {
    
    public typealias Item = T
    
    public let dataContext: NSManagedObjectContext
    public let entityDescription: NSEntityDescription
    
    public var offset: Int = 0
    public var limit: Int = 0
    public var batchSize: Int = DataContextOptions.defaultBatchSize
    
    public var predicate: NSPredicate? = nil
    public var sortDescriptors: [NSSortDescriptor]? = nil
    
    public init(dataContext: NSManagedObjectContext) {
        //
        let managedObjectClassName = NSStringFromClass(T.self)
        
        var entityDescription: NSEntityDescription
        let cacheKey = Duplet(managedObjectClassName,dataContext)
        
        if let cachedEntityDescription = cachedEntityDescriptions[cacheKey] {
            entityDescription = cachedEntityDescription
        } else {
            let persistentStoreCoordinator = dataContext.persistentStoreCoordinator!
            let managedObjectModel = persistentStoreCoordinator.managedObjectModel
            
            
            entityDescription = managedObjectModel.entities.filter({ $0.managedObjectClassName == managedObjectClassName }).first!
            
            
            entityDescription = NSEntityDescription.entityForName(entityDescription.name!, inManagedObjectContext: dataContext)!
            
            cachedEntityDescriptions[cacheKey] = entityDescription
        }
        
        
        self.dataContext = dataContext
        self.entityDescription = entityDescription
    }
    
}
