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

}
