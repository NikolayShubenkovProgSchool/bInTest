//
//  GroupAnnotationView.swift
//  bInTest
//
//  Created by Sergey Minakov on 31.05.16.
//  Copyright © 2016 Naithar. All rights reserved.
//

import UIKit
import MapKit

class GroupAnnotationView: MapAnnotationView {
    
    private(set) var titleLabel: UILabel?
    
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
        let title = UILabel()
        
        title.textColor = UIColor.blackColor()
        title.textAlignment = .Center
        title.layer.masksToBounds = false
        
        self.layer.backgroundColor = UIColor.redColor().CGColor
        self.layer.masksToBounds = false
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
        self.addSubview(title)
        
        self.titleLabel = title
    }
    
    final override func resetAnnotation() {
        
        guard let annotation = self.annotation as? MapAnnotation else { return }
        
        if case .Group(let count) = annotation.type {
            self.titleLabel?.text = "\(count)"
        }
    }
    
    private func resetSize() {
        guard let title = self.titleLabel else { return }
        title.sizeToFit()
        let dimention = round(max(title.bounds.width, title.bounds.height) + 20)
        let size = CGSize(width: dimention - 4, height: dimention - 4)
        let origin = CGPoint(x: 2, y: 2)
        title.frame = CGRect(origin: origin, size: size)
        
        let mainSize = CGSize(width: dimention, height: dimention)
        self.bounds.size = mainSize
        self.layer.cornerRadius = mainSize.width / 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.resetSize()
        
        self.layoutIfNeeded()
    }
}
