//
//  NSURLSession+bInTest.swift
//  bInTest
//
//  Created by Sergey Minakov on 01.06.16.
//  Copyright © 2016 Naithar. All rights reserved.
//

import Foundation

extension NSURLSession {
    func synchronousDataTaskWithURL(url: NSURL) -> (NSData?, NSURLResponse?, NSError?) {
        var data: NSData?, response: NSURLResponse?, error: NSError?
        
        let semaphore = dispatch_semaphore_create(0)
        
        dataTaskWithURL(url) {
            data = $0; response = $1; error = $2
            dispatch_semaphore_signal(semaphore)
            }.resume()
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
        return (data, response, error)
    }
}
