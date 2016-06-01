//
//  CLCoordinate+bInTest.swift
//  bInTest
//
//  Created by Sergey Minakov on 01.06.16.
//  Copyright © 2016 Naithar. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D {
    
    func range(to point: CLLocationCoordinate2D) -> Double {
        let latDelta = self.latitude-point.latitude;
        let lonDelta = self.longitude-point.longitude;
        return latDelta*latDelta + lonDelta*lonDelta;
    }
}