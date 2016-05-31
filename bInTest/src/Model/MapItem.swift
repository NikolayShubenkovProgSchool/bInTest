//
//  MapItem.swift
//  bInTest
//
//  Created by Sergey Minakov on 31.05.16.
//  Copyright © 2016 Naithar. All rights reserved.
//

import Foundation

struct MapItem {
    
    var photoId: String
    var serverId: String
    var farmId: Int
    var secret: String
    
    var lat: Double
    var lon: Double
}

extension MapItem: Hashable {
    
    var hashValue: Int {
        let idString = "\(self.photoId)-\(self.serverId)-\(farmId)-\(secret)"
        return idString.hashValue
    }
    
}

func ==(lhs: MapItem, rhs: MapItem) -> Bool {
    let result = lhs.hashValue == rhs.hashValue
    return result
}