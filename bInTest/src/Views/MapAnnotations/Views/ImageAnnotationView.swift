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
    private var timestamp: NSTimeInterval = 0
    
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
        imageView.layer.backgroundColor = UIColor.groupTableViewBackgroundColor().CGColor
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.masksToBounds = false
        self.addSubview(imageView)
        
        self.imageView = imageView
    }
    
    final override func resetAnnotation() {
        self.imageView?.image = nil
        guard let annotation = self.annotation as? MapAnnotation else { return }
        
        if case .Image(let item) = annotation.type {
            self.timestamp = NSDate().timeIntervalSince1970
            let timestamp = self.timestamp
            ModelLoader.requestImage(photo: item) { [weak self] image in
                guard self?.timestamp == timestamp else { return }
                self?.imageView?.image = image
            }
        }
    }
}
