//
//  MapViewController+Model.swift
//  bInTest
//
//  Created by Sergey Minakov on 31.05.16.
//  Copyright © 2016 Naithar. All rights reserved.
//

import UIKit

extension MapViewController {
    
    final func refresh(annotations: [MapAnnotation]) {
        guard let map = self.mapView where annotations.count > 0 else { return }
        
        map.removeAnnotations(map.annotations)
        map.addAnnotations(annotations)
    }
}
