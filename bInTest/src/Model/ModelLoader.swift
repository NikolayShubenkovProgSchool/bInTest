//
//  ModelLoader.swift
//  bInTest
//
//  Created by Sergey Minakov on 31.05.16.
//  Copyright © 2016 Naithar. All rights reserved.
//

import UIKit

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

class ModelLoader {
    
    static let apiKey = "b49d87bfd659c5768ab0eafa74f2b6a5"
    
    static let photoQueue = { () -> NSOperationQueue in
        let operation = NSOperationQueue()
        operation.name = "photo"
        operation.maxConcurrentOperationCount = 10
       return operation
    }()
    
    static let photoSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                                           delegate: nil,
                                           delegateQueue: ModelLoader.photoQueue)
    
//    static var photoTask: NSURLSessionTask?
    
    static let locationSession = { () -> NSURLSession in
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 10
       return NSURLSession(configuration: configuration)
    }()
    static let imageSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    static func requestPhotos(lat lat: Double, lon: Double, contains: (MapItem) -> (Bool), closure: (array: [MapItem]) -> ()) {
        
        guard let url = NSURL(string: "https://api.flickr.com/services/rest/?" +
            "format=json&method=flickr.photos.search&has_geo=true&" +
            "tags=cat&per_page=50" +
            "&api_key=\(ModelLoader.apiKey)&lat=\(lat)&lon=\(lon)&radius=3&nojsoncallback=?") else {
                NSLog("error in request photos url")
                return
        }
        
//        photoTask?.cancel()
        
        
        ModelLoader.photoSession.dataTaskWithURL(url) { data, response, error in
            guard let data = data where error == nil else {
                NSLog("error in request photos callback \(error)")
                return
            }
            
            do {
                let parsedData = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                
                guard let json = parsedData as? [String : AnyObject] else { return }
                guard let photos = json["photos"] as? [String : AnyObject] else { return }
                guard let array = photos["photo"] as? [[String: AnyObject]] else { return }
                
                var resultArray = [MapItem]()
                
                NSLog("started \(array.count)")
                
                for item in array {
                    autoreleasepool {
                        guard let photoId = item["id"] as? String,
                            let serverId = item["server"] as? String,
                            let farmId = item["farm"] as? Int,
                            let secret = item["secret"] as? String else { return }
                        
                        var mapItem = MapItem(photoId: photoId,
                            serverId: serverId,
                            farmId: farmId,
                            secret: secret,
                            lat: -1,
                            lon: -1)
                        
                        guard !contains(mapItem) else { return }
                        
                        (mapItem.lat, mapItem.lon) = requestLocation(photo: photoId)
                        
                        guard mapItem.lat != -1 && mapItem.lon != -1 else { return }
                        
                        resultArray.append(mapItem)
                    }
                }
                
                closure(array: resultArray)
                
            } catch {
                NSLog("error in requst photos processing \(error)")
            }
            
        }.resume()
        
//        photoTask?.resume()
    }
    
    static func requestLocation(photo id: String) -> (lat: Double, lon: Double) {
        guard let url = NSURL(string: "https://api.flickr.com/services/rest/?" +
            "format=json&method=flickr.photos.geo.getLocation&" +
            "photo_id=\(id)&api_key=\(ModelLoader.apiKey)&nojsoncallback=?") else {
                NSLog("error in request location url")
                return (lat: -1, lon: -1)
        }
        
        let (responseData, _, error) = ModelLoader.locationSession.synchronousDataTaskWithURL(url)
        
        guard let data = responseData where error == nil else {
            NSLog("error in request location response")
            return (lat: -1, lon: -1)
        }
        
        do {
            
            let parsedData = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            
            guard let json = parsedData as? [String : AnyObject] else {
                return (lat: -1, lon: -1)
            }
            
            guard let photo = json["photo"] as? [String : AnyObject] else {
                return (lat: -1, lon: -1)
            }
            
            guard let location = photo["location"] as? [String : AnyObject] else {
                return (lat: -1, lon: -1)
            }
            
            
            let lat = Double(location["latitude"] as? String ?? "") ?? -1
            let lon = Double(location["longitude"] as? String ?? "") ?? -1
            
            return (lat: lat, lon: lon)
        } catch {
            NSLog("error in requst photos processing \(error)")
            return (lat: -1, lon: -1)
        }
    }
    
    static func requestImage(photo data: MapItem, closure: (UIImage?) -> ()) {
        //http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
        
        guard let url = NSURL(string: "http://farm\(data.farmId).staticflickr.com/\(data.serverId)/\(data.photoId)_\(data.secret)_s.jpg") else {
            dispatch_async(dispatch_get_main_queue()) {
                closure(nil)
            }
            return
        }
        
        ModelLoader.photoSession.dataTaskWithURL(url) { data, _, error in
            guard let data = data where error == nil,
                let image = UIImage(data: data) else {
                    dispatch_async(dispatch_get_main_queue()) {
                        closure(nil)
                    }
                    return
            }
            
            if (NSThread.isMainThread()) {
                closure(image)
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    closure(image)
                }
            }
            return
        }.resume()
        
    }
}