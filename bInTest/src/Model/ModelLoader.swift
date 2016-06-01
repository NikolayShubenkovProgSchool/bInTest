//
//  ModelLoader.swift
//  bInTest
//
//  Created by Sergey Minakov on 31.05.16.
//  Copyright © 2016 Naithar. All rights reserved.
//

import UIKit

class ModelLoader {
    
    static let baseUrl = "https://api.flickr.com/services/rest/"
    static let baseParameters = "format=json&&api_key=\(ModelLoader.apiKey)&nojsoncallback=?"
    static let apiKey = "b49d87bfd659c5768ab0eafa74f2b6a5"
    
    static let photoSession = { () -> NSURLSession in
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let queue = NSOperationQueue()
        queue.name = "photo"
        queue.maxConcurrentOperationCount = 5
        
        return NSURLSession(configuration: configuration,
                            delegate: nil,
                            delegateQueue: queue)
    }()
    
    static let locationSession = { () -> NSURLSession in
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 10
        return NSURLSession(configuration: configuration)
    }()
    
    
    static let imageSession = { () -> NSURLSession in
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: configuration)
    }()
    
    static func photosUrl(lat lat: Double, lon: Double) -> NSURL? {
        return NSURL(string: "\(baseUrl)?\(baseParameters)" +
            "&method=flickr.photos.search&has_geo=true&" +
            "tags=cat&per_page=50" +
            "&lat=\(lat)&lon=\(lon)&radius=3")
    }
    
    static func requestPhotos(lat lat: Double, lon: Double, contains: (MapItem) -> (Bool), closure: (array: [MapItem]) -> ()) {
        
        guard let url = self.photosUrl(lat: lat, lon: lon) else {
                NSLog("error in request photos url")
                return
        }
        
        self.photoSession.dataTaskWithURL(url) { data, response, error in
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
    }
    
    static func requestLocation(photo id: String) -> (lat: Double, lon: Double) {
        guard let url = NSURL(string: "https://api.flickr.com/services/rest/?" +
            "format=json&method=flickr.photos.geo.getLocation&" +
            "photo_id=\(id)&api_key=\(ModelLoader.apiKey)&nojsoncallback=?") else {
                NSLog("error in request location url")
                return (lat: -1, lon: -1)
        }
        
        let (responseData, _, error) = self.locationSession.synchronousDataTaskWithURL(url)
        
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
        guard let url = NSURL(string: "http://farm\(data.farmId).staticflickr.com/\(data.serverId)/\(data.photoId)_\(data.secret)_s.jpg") else {
            dispatch_async(dispatch_get_main_queue()) {
                closure(nil)
            }
            return
        }
        
        self.imageSession.dataTaskWithURL(url) { data, _, error in
            guard let data = data where error == nil,
                let image = UIImage(data: data) else {
                    dispatch_async(dispatch_get_main_queue()) {
                        closure(nil)
                    }
                    return
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                closure(image)
            }
            }.resume()
        
    }
}