//
//  ViewController.swift
//  BrightFuturesApp
//
//  Created by Barrett Clark on 5/29/15.
//  Copyright (c) 2015 Sabre Labs. All rights reserved.
//

import UIKit
import Argo
import Runes
import BrightFutures
import SwiftHTTP
import Haneke

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "https://chronic-flight-search.herokuapp.com/cannon_ball/iata_resolve/DFW"
        futureCacheGet(url).flatMap { data in
            self.futureJSON(data)
        }.flatMap { json in
            self.futureAirport(json)
        }.onSuccess { airportResponse in
            NSLog("Airport: \(airportResponse.airport.iataCode)")
        }
    }
    
    func futureCacheGet(urlPath: String) -> Future<NSData> {
        let promise = Promise<NSData>()
        let cache = Cache<NSData>(name: "chronic")
        cache.fetch(URL: NSURL(string: urlPath)!).onSuccess { JSON in
            promise.success(JSON)
        }.onFailure { error in
            promise.failure(error!)
        }
        return promise.future
    }
    func futureGet(urlPath: String) -> Future<NSData> {
        let promise = Promise<NSData>()
        HTTPTask().GET(urlPath, parameters: nil) { (response: HTTPResponse) -> Void in
            if (response.responseObject != nil)  { promise.success(response.responseObject! as! NSData)  }
            if (response.error != nil)           { promise.failure(response.error!) }
        }
        return promise.future
    }
    func futureJSON(data: NSData) -> Future<AnyObject> {
        let promise = Promise<AnyObject>()

        var error: NSError?
        var json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &error)
        if (json != nil)  { promise.success(json!)  }
        if (error != nil) { promise.failure(error!) }

        return promise.future
    }
    func futureAirport(json: AnyObject) -> Future<AirportResponse> {
        let promise = Promise<AirportResponse>()
        let airportResponse: AirportResponse? = decode(json)
        if (airportResponse != nil) {
            promise.success(airportResponse!)
        } else {
            promise.failure(NSError(domain: "futureAirportDomain", code: 0, userInfo: nil))
        }
        return promise.future
    }
}
