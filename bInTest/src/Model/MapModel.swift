//
//  MapModel.swift
//  bInTest
//
//  Created by Sergey Minakov on 31.05.16.
//  Copyright © 2016 Naithar. All rights reserved.
//

import Foundation
import CoreLocation

class MapModel {
    
    private var mapItems: Set<MapItem> = []
    
    weak var view: MapViewController?
//    
//    subscript(index: Int) -> MapItem? {
//        get {
//            guard index > self.mapItems.count else {
//                return nil
//            }
//            
//            return self.mapItems[index]
//        }
//    }
    
    init(_ view: MapViewController?) {
        self.view = view
    }
    
    private func radius(lat1: Double, lat2: Double, lng1: Double, lng2: Double) -> Double {
        let latDelta = lat1-lat2;
        let lonDelta = lng1-lng2;
        return latDelta*latDelta + lonDelta*lonDelta;
    }
    
    final func request(lat lat: Double, lon: Double, span: Double) {
        
        ModelLoader.requestPhotos(lat: lat, lon: lon, contains: { item in
            return self.mapItems.contains(item)
        }, closure: { [weak self] array in
            
            for item in array {
                self?.mapItems.insert(item)
            }
            
            self?.reload(span)
        })
    }
    
    
//    private var refreshTimestamp: NSTimeInterval = 0
    private func reload(span: Double) {
        
//        self.refreshTimestamp = NSDate().timeIntervalSince1970
//        let refreshTimestamp = self.refreshTimestamp
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            NSLog("finished \(self.mapItems.count)")
            
            
            var annotations = [MapAnnotation]()
            
            for item in self.mapItems {
                
                var foundGroupItem: MapAnnotation?
                
                let new = MapAnnotation()
                new.type = .Image(item: item)
                new.coordinate = CLLocationCoordinate2D(latitude: item.lat, longitude: item.lon)
                
                for annotation in annotations {
                    if self.radius(annotation.coordinate.latitude, lat2: new.coordinate.latitude, lng1: annotation.coordinate.longitude, lng2: new.coordinate.longitude) < span {
                        foundGroupItem = annotation
                        break
                    }
                }
                
                if let group = foundGroupItem {
                    switch group.type {
                    case .Group(let count):
                        group.type = .Group(count: count + 1)
                    default:
                        group.type = .Group(count: 2)
                    }
                } else {
                    annotations.append(new)
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
//                guard self?.refreshTimestamp == refreshTimestamp else { return }
                self?.view?.refresh(annotations)
            }
        }
    }
}
