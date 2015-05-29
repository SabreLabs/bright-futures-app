//
//  airport.swift
//  BrightFuturesApp
//
//  Created by Barrett Clark on 5/29/15.
//  Copyright (c) 2015 Sabre Labs. All rights reserved.
//

import Foundation
import Argo
import Runes

struct AirportResponse {
    let airport: Airport
}

extension AirportResponse: Decodable {
    static func create(airport: Airport) -> AirportResponse {
        return AirportResponse(airport: airport)
    }
    static func decode(j: JSON) -> Decoded<AirportResponse> {
        return AirportResponse.create
            <^> j <| "airport"
    }
}

struct Airport {
    let id: Int
    let cityName: String
    let stateCode: String
    let countryCode: String
    let latitude: Double
    let longitude: Double
    let airportName: String
    let iataCode: String
}

extension Airport: Decodable {
    static func create(id: Int)(cityName: String)(stateCode: String)(countryCode: String)(latitude: Double)(longitude: Double)(airportName: String)(iataCode: String) -> Airport {
        return Airport(id: id, cityName: cityName, stateCode: stateCode, countryCode: countryCode, latitude: latitude, longitude: longitude, airportName: airportName, iataCode: iataCode)
    }
    static func decode (j: JSON) -> Decoded<Airport> {
        return Airport.create
            <^> j <| "id"
            <*> j <| "city_name"
            <*> j <| "state_code"
            <*> j <| "country_code"
            <*> j <| "latitude"
            <*> j <| "longitude"
            <*> j <| "poi_name"
            <*> j <| "vendor_code"
    }
}
