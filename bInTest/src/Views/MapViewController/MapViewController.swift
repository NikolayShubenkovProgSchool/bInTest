//
//  MapViewController.swift
//  bInTest
//
//  Created by Sergey Minakov on 31.05.16.
//  Copyright © 2016 Naithar. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    private(set) var mapModel: MapModel?
    private(set) var mapView: MKMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.setupModel()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.reload()
    }
    
    private func setupViews() {
        self.view.backgroundColor = .whiteColor()
        
        self.setupMapView()
    }
    
    private func setupMapView() {
        let bounds = self.view.bounds
        let mapView = MKMapView(frame: bounds)
        mapView.delegate = self
        mapView.autoresizingMask = [ .FlexibleWidth, .FlexibleHeight ]
        
        self.mapView = mapView
        
        self.view.addSubview(mapView)
    }
    
    private func setupModel() {
        self.mapModel = MapModel(self)
    }
}