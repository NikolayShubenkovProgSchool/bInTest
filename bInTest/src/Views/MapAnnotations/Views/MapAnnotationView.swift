//
//  MapAnnotationView.swift
//  bInTest
//
//  Created by Sergey Minakov on 31.05.16.
//  Copyright © 2016 Naithar. All rights reserved.
//

import MapKit

class MapAnnotationView: MKAnnotationView {

    override var annotation: MKAnnotation? {
        didSet {
            guard let new = self.annotation as? MapAnnotation,
                let old = oldValue as? MapAnnotation else {
                        self.resetAnnotation()
                    return
            }
            
            if new.id != old.id {
                self.resetAnnotation()
            }
        }
    }
    
    func resetAnnotation() {
        
    }
}
