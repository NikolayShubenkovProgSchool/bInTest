//
//  MapItem+CoreDataProperties.swift
//  bInTest
//
//  Created by Sergey Minakov on 01.06.16.
//  Copyright © 2016 Naithar. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MapItem {

    @NSManaged var photoId: String?
    @NSManaged var serverId: String?
    @NSManaged var farmId: Int64
    @NSManaged var secret: String?
    @NSManaged var lat: Double
    @NSManaged var lon: Double

}
