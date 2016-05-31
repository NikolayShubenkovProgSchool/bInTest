//
//  ModelLoader.swift
//  bInTest
//
//  Created by Sergey Minakov on 31.05.16.
//  Copyright © 2016 Naithar. All rights reserved.
//

import Foundation

class ModelLoader {
    
    func requestPhotos(lat lat: Double, lon: Double) {
        //https://api.flickr.com/services/rest/?&format=json&method=flickr.photos.search&has_geo=true&tags=cat&api_key=b49d87bfd659c5768ab0eafa74f2b6a5&per_page=500&lat=55&lon=37&radius=32&nojsoncallback=?

    }
    
    func requestLocation(photo id: Int) {
        //https://api.flickr.com/services/rest/?&format=json&method=flickr.photos.geo.getLocation&photo_id=27364138665&api_key=b49d87bfd659c5768ab0eafa74f2b6a5&per_page=50&nojsoncallback=?

    }
    
    func requestImage(photo data: MapItem) {
        //http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
    }
}