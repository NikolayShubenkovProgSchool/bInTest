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
    private var refreshTimestamp: NSTimeInterval = 0
    
    weak var view: MapViewController?
    
    init(_ view: MapViewController?) {
        self.view = view
    }
    
    final func request(lat lat: Double, lon: Double, range: Double) {
        self.refreshTimestamp = NSDate().timeIntervalSince1970
        self.reload(range)
        
        ModelLoader.requestPhotos(lat: lat, lon: lon, contains: { item in
            return self.mapItems.contains(item)
        }, closure: { [weak self] array in
            
            let count = self?.mapItems.count
            for item in array {
                self?.mapItems.insert(item)
            }
            
            guard count != self?.mapItems.count else { return }
            self?.reload(range)
        })
    }
    
    private func reload(range: Double) {
        let refreshTimestamp = self.refreshTimestamp
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self] in
            guard let strongSelf = self else { return }
            NSLog("finished \(strongSelf.mapItems.count)")
            guard strongSelf.refreshTimestamp == refreshTimestamp else { return }
            
            var annotations = [MapAnnotation]()
            
            for item in strongSelf.mapItems {
                guard strongSelf.refreshTimestamp == refreshTimestamp else { return }
                var foundGroupItem: MapAnnotation?
                
                let new = MapAnnotation()
                new.type = .Image(item: item)
                new.coordinate = CLLocationCoordinate2D(latitude: item.lat, longitude: item.lon)
                
                for annotation in annotations {
                    if annotation.coordinate.range(to: new.coordinate) < range {
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
                guard self?.refreshTimestamp == refreshTimestamp else { return }
                self?.view?.refresh(annotations)
            }
        }
    }
}
