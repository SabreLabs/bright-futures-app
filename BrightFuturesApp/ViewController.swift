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
        
        futureGet("http://localhost:3000/cannon_ball/iata_resolve/LGA").onSuccess { data in
            futureJSON(data).onSuccess { json in
                let airportResponse: AirportResponse? = decode(json)
                println("Future \(airportResponse?.airport.iataCode)")
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

        var err: NSError?
        var json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &err)
        if let j: AnyObject = json {
            promise.success(j)
        } else {
            promise.failure(err!)
        }

        return promise.future
    }
}
