//
//  UIImage+bInTest.swift
//  bInTest
//
//  Created by Sergey Minakov on 01.06.16.
//  Copyright © 2016 Naithar. All rights reserved.
//

import UIKit

extension UIImage {
    
    public func scaled(to size: CGSize) -> UIImage {
        let imageAspectRatio = self.size.width / self.size.height
        let canvasAspectRatio = size.width / size.height
        
        var resizeFactor: CGFloat
        
        if imageAspectRatio > canvasAspectRatio {
            resizeFactor = size.height / self.size.height
        } else {
            resizeFactor = size.width / self.size.width
        }
        
        let scaledSize = CGSize(width: self.size.width * resizeFactor, height: self.size.height * resizeFactor)
        let origin = CGPoint(x: (size.width - scaledSize.width) / 2.0, y: (size.height - scaledSize.height) / 2.0)
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        drawInRect(CGRect(origin: origin, size: scaledSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    public func rounded(with radius: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.mainScreen().scale)
        let scaledRadius = radius
        
        let rect = CGRect(origin: .zero, size: self.size)
        let clippingPath = UIBezierPath(roundedRect: rect, cornerRadius: scaledRadius)
        clippingPath.addClip()
        
        drawInRect(CGRect(origin: CGPointZero, size: self.size))
        
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage
    }
}
