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
    
    final func reload() {
        guard let mapView = self.mapView else { return }
        
        let center = mapView.region.center
        let latitudeDimension = mapView.region.span.latitudeDelta
        let longitudeDimension = mapView.region.span.longitudeDelta
        let maxDimension = max(mapView.bounds.height, mapView.bounds.width)
        let delta = Double(maxDimension) / 50.0
        
        let latDelta = latitudeDimension / delta
        let lonDelta = longitudeDimension / delta
        
        let range = latDelta * latDelta + lonDelta * lonDelta
        
        self.mapModel?.request(lat: center.latitude, lon: center.longitude, range: range)
    }
}
