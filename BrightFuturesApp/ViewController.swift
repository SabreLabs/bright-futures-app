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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        futureGet("http://chronic-flight-search.herokuapp.com/cannon_ball/iata_resolve/LGA").onSuccess { data in
            futureJSON(data).onSuccess { json in
                futureAirport(json).onSuccess { airportResponse in
                    NSLog("Airport: \(airportResponse.airport.iataCode)")
                }
            }
        }
    }
    
    func futureGet(urlPath: String) -> Future<NSData> {
        let promise = Promise<NSData>()

        var url: NSURL = NSURL(string: urlPath)!
        var request: NSURLRequest = NSURLRequest(URL: url)
        let queue: NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (data != nil)  { promise.success(data!)  }
            if (error != nil) { promise.failure(error!) }
        })
        
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
