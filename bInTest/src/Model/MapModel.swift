//
//  MapModel.swift
//  bInTest
//
//  Created by Sergey Minakov on 31.05.16.
//  Copyright © 2016 Naithar. All rights reserved.
//

import Foundation

class MapModel {
    
    private var mapItems: [MapItem] = []
    
    weak var view: MapViewController?
    
    subscript(index: Int) -> MapItem? {
        get {
            guard index > self.mapItems.count else {
                return nil
            }
            
            return self.mapItems[index]
        }
    }
    
    init(_ view: MapViewController?) {
        self.view = view
    }
    
    final func request(lat lat: Double, lon: Double, span: Double) {
        ModelLoader.requestPhotos(lat: lat, lon: lon) { [weak self] array in
            self?.mapItems = array
            NSLog("finished")
        }
    }
}
