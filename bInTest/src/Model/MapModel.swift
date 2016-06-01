//
//  MapModel.swift
//  bInTest
//
//  Created by Sergey Minakov on 31.05.16.
//  Copyright © 2016 Naithar. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

class MapModel {
    
    private var range: Double = 0
    private var prevCount = 0
    
    weak var view: MapViewController?
    
    init(_ view: MapViewController?) {
        self.view = view
    }
    
    final func request(lat lat: Double, lon: Double, range: Double) {
        self.range = range
        self.reload()
        
        ModelLoader.requestPhotos(lat: lat, lon: lon, contains: { photoId, serverId, secret, farmId in
            return LocalStore.instance.contains(photoId: photoId, serverId: serverId, secret: secret, farmId: farmId)
            }, closure: { [weak self] in
                let count = LocalStore.instance.count
                if count != self?.prevCount {
                    NSLog("Preparing for reload")
                    self?.reload()
                }
                
                self?.prevCount = count
            })
    }
    
    private func reload() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self] in
            let request = NSFetchRequest(entityName: "MapItem")
            
            guard let result = try? LocalStore.instance.context.executeFetchRequest(request),
                let mapItems = result as? [MapItem] else {
                    NSLog("Couldn't request map items")
                    return
            }
            
            guard let strongSelf = self where mapItems.count > 0 else { return }
            NSLog("Current stored photos count: \(mapItems.count)")
            
            var annotations = [MapAnnotation]()
            
            for item in mapItems {
                var foundGroupItem: MapAnnotation?
                
                let new = MapAnnotation()
                new.type = .Image(item: item)
                
                new.coordinate = CLLocationCoordinate2D(latitude: item.lat,
                                                        longitude: item.lon)
                
                for annotation in annotations {
                    if annotation.coordinate.range(to: new.coordinate) < strongSelf.range {
                        foundGroupItem = annotation
                        break
                    }
                }
                
                if let group = foundGroupItem {
                    if case .Group(let count) = group.type {
                        let newCount = count + 1
                        group.type = .Group(count: newCount)
                        
                        let lat = group.coordinate.latitude * Double(count) + new.coordinate.latitude
                        let lon = group.coordinate.longitude * Double(count) + new.coordinate.longitude
                        
                        group.coordinate = CLLocationCoordinate2D(latitude: lat / Double(newCount), longitude: lon / Double(newCount))
                    } else {
                        group.type = .Group(count: 2)
                        
                        let lat = group.coordinate.latitude + new.coordinate.latitude
                        let lon = group.coordinate.longitude + new.coordinate.longitude
                        
                        group.coordinate = CLLocationCoordinate2D(latitude: lat / 2, longitude: lon / 2)
                    }
                } else {
                    annotations.append(new)
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                NSLog("Will display annotations")
                self?.view?.refresh(annotations)
            }
        }
    }
}
