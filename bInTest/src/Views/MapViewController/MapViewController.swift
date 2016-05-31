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

    private var mapModel: MapModel?
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
        
        self.setupNavigationItem()
        self.setupMapView()
    }
    
    private func setupNavigationItem() {
        let refreshSelector = #selector(MapViewController.refreshBarAction(_:))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: refreshSelector)
        self.navigationItem.rightBarButtonItem = refreshButton
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
    
    final func reload() {
        guard let mapView = self.mapView else { return }
        
        let center = mapView.region.center
        let maxSpan = min(mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta)
        let maxDimention = min(mapView.frame.height, mapView.frame.width)
        let delta = Int(maxDimention / 55)
        let span = maxSpan / Double(delta)
        
        self.mapModel?.request(lat: center.latitude, lon: center.longitude, span: span / 2)
    }
}


//MARK: Selectors

extension MapViewController {
    
    func refreshBarAction(button: UIBarButtonItem?) {
        
    }
}