//
//  location.swift
//  SwiftLabb1
//
//  Created by Jonathan Thunberg on 2020-02-03.
//  Copyright © 2020 Jonathan Thunberg. All rights reserved.
//

import UIKit

struct City : Codable {
    let cityName : String
    let cityInfo : CityInfo
    
    private enum CodingKeys : String, CodingKey {
        case cityName = "city_name", cityInfo
    }
    
    
}


struct CityInfo: Codable {
    let temp : Int
    let feelsLikeTemp : Int
    var maxTemp : Int
    var minTemp : Int
    var pressure : Int
    var humidity : Int
    
    let weatherStatus : String
    let iconId : String
}
