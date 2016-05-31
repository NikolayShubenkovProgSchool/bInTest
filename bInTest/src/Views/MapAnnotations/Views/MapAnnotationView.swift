//
//  MapAnnotationView.swift
//  bInTest
//
//  Created by Sergey Minakov on 31.05.16.
//  Copyright © 2016 Naithar. All rights reserved.
//

import MapKit

class MapAnnotationView: MKAnnotationView {

    private var old: MapAnnotation?
    private var new: MapAnnotation?
    override var annotation: MKAnnotation? {
        didSet {
            self.resetAnnotation()
        }
    }
    
    func resetAnnotation() {
        
    }
}
