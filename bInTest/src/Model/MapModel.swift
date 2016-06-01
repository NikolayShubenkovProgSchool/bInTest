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
    private var range: Double = 0
    
    weak var view: MapViewController?
    
    init(_ view: MapViewController?) {
        self.view = view
    }
    
    final func request(lat lat: Double, lon: Double, range: Double) {
        self.range = range
        self.reload()
        
        ModelLoader.requestPhotos(lat: lat, lon: lon, contains: { item in
            return self.mapItems.contains(item)
        }, closure: { [weak self] array in
            
            let count = self?.mapItems.count
            for item in array {
                self?.mapItems.insert(item)
            }
            
            guard count != self?.mapItems.count else { return }
            self?.reload()
        })
    }
    
    private func reload() {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self] in
            guard let strongSelf = self where strongSelf.mapItems.count > 0 else { return }
            NSLog("finished \(strongSelf.mapItems.count)")
            
            var annotations = [MapAnnotation]()
            
            for item in strongSelf.mapItems {
                var foundGroupItem: MapAnnotation?
                
                let new = MapAnnotation()
                new.type = .Image(item: item)
                new.coordinate = CLLocationCoordinate2D(latitude: item.lat, longitude: item.lon)
                
                for annotation in annotations {
                    if annotation.coordinate.range(to: new.coordinate) < strongSelf.range {
                        foundGroupItem = annotation
                        break
                    }
                }
                
                if let group = foundGroupItem {
                    if case .Group(let count) = group.type {
                        group.type = .Group(count: count + 1)
                    } else {
                        group.type = .Group(count: 2)
                    }
                } else {
                    annotations.append(new)
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                NSLog("displaying")
                self?.view?.refresh(annotations)
            }
        }
    }
}
