//
//  MapAnnotation.swift
//  bInTest
//
//  Created by Sergey Minakov on 31.05.16.
//  Copyright © 2016 Naithar. All rights reserved.
//

import UIKit
import MapKit

class MapAnnotation: MKPointAnnotation {

    enum Type {
        case Default
        case Group(count: Int)
        case Image(id: Int)
    }
    
    var type: Type = .Default

    var reuseId: String {
        switch self.type {
        case .Default:
            return "default"
        case .Image:
            return "image"
        case .Group:
            return "group"
        }
    }
}
