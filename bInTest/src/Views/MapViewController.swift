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

    private var mapView: MKMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    private func setupViews() {
        self.view.backgroundColor = .whiteColor()
        
        self.setupNavigationItem()
        self.setupMapView()
    }
    
    private func setupNavigationItem() {
        let refreshSelector = #selector(MapViewController.refresh(_:))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: refreshSelector)
        self.navigationItem.rightBarButtonItem = refreshButton
    }
    
    private func setupMapView() {
        let bounds = self.view.bounds
        let mapView = MKMapView(frame: bounds)
        mapView.autoresizingMask = [ .FlexibleWidth, .FlexibleHeight ]
        self.view.addSubview(mapView)
    }
}


//MARK: Selectors

extension MapViewController {
    
    func refresh(button: UIBarButtonItem?) {
        
    }
}