//
//  MapViewController+Map.swift
//  bInTest
//
//  Created by Sergey Minakov on 31.05.16.
//  Copyright © 2016 Naithar. All rights reserved.
//

import UIKit
import MapKit

extension MapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MapAnnotation else { return nil }
        
        if case .Default = annotation.type {
            return nil
        }
        
        guard let resultView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotation.reuseId) else {
            switch annotation.type {
            case .Image:
                return ImageAnnotationView(annotation: annotation, reuseIdentifier: annotation.reuseId)
            default:
                return GroupAnnotationView(annotation: annotation, reuseIdentifier: annotation.reuseId)
            }
        }
        
        resultView.annotation = annotation
        return resultView
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.reload()
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: false)
    }
}
