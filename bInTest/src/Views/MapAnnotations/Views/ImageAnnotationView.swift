//
//  ImageAnnotationView.swift
//  bInTest
//
//  Created by Sergey Minakov on 31.05.16.
//  Copyright © 2016 Naithar. All rights reserved.
//

import UIKit
import MapKit

class ImageAnnotationView: MapAnnotationView {
    
    private(set) var imageView: UIImageView?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    private func commonInit() {
        self.bounds.size = CGSize(width: 50, height: 50)
        
        let imageView = UIImageView(frame: self.bounds)
        imageView.layer.backgroundColor = UIColor.grayColor().CGColor
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = false
        self.addSubview(imageView)
        
        self.imageView = imageView
    }
    
    final override func resetAnnotation() {
        
    }
}
