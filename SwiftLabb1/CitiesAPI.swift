//
//  CitiesAPI.swift
//  SwiftLabb1
//
//  Created by Jonathan Thunberg on 2020-02-04.
//  Copyright © 2020 Jonathan Thunberg. All rights reserved.
//

import Foundation
import SwiftyJSON


struct CitiesAPI {
    
    
    func getClosestCity(_ lat : Double, _ lon : Double, completion: @escaping( Result<City, Error>) -> Void) {
        
        let baseURL: String = "http://78.71.86.80/thunbergCitiesAPI/getClosest.php"
   
        let urlString : String = baseURL + "?lat=\(lat)&lon=\(lon)"

        guard let url: URL = URL(string: urlString) else { return }

     
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let unwrappedError = error {
                completion(.failure(unwrappedError))
                return
            }
            if let unwrappedData = data {
                do {

                    
                    let json = try JSON(data: unwrappedData)
                    
                    let cityName : String = json["name"].string ?? ""
                                

                    self.getCityInfo(cityName) { (result) in
                        switch result {
                        case .success(let cityInfo):
                            let city: City = City(cityName: cityName, cityInfo: cityInfo)
                            completion(.success(city))
                        case .failure(let error): print("Error \(error)")
                        }
                    }
                    
                    
                } catch {
                    print("Couldnt parse JSON..")
                }
                
            }
        }
        task.resume()
    }
    
    
    
    func getCityInfo(_ cityName: String, completion: @escaping( Result<CityInfo, Error>) -> Void) {
        
        let baseURL : String = "https://api.openweathermap.org/data/2.5/weather?appid=7792c57a944a989c65e5bb8071e9f7de"
        
        let urlString : String = (baseURL + "&q=\(cityName)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        guard let url: URL = URL(string: urlString) else { return }

      
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let unwrappedError = error {
                completion(.failure(unwrappedError))
                return
            }
            if let unwrappedData = data {
                do {

                    let json = try JSON(data: unwrappedData)
                

                    let celsiusTemp : Double = Double(json["main"]["temp"].double ?? 0.0) - 273.15
                    let feelsLikeTemp : Double = Double(json["main"]["feels_like"].double ?? 0.0) - 273.15
                    let maxTemp : Double = Double(json["main"]["temp_max"].double ?? 0.0) - 273.15
                    let minTemp : Double = Double(json["main"]["temp_min"].double ?? 0.0) - 273.15
                    let pressure : Double = Double(json["main"]["pressure"].double ?? 0.0)
                    let humidity : Double = Double(json["main"]["humidity"].double ?? 0.0)
                    
                
                    
                    let iconId : String = String(json["weather"][0]["icon"].string ?? "")
                    let weatherStatus : String = String(json["weather"][0]["main"].string ?? "")
        
                  
                    let cityInfo: CityInfo = CityInfo(temp: Int(celsiusTemp.rounded()), feelsLikeTemp: Int(feelsLikeTemp), maxTemp: Int(maxTemp), minTemp: Int(minTemp), pressure: Int(pressure), humidity: Int(humidity), weatherStatus: String(weatherStatus), iconId: iconId)
                    completion(.success(cityInfo))
                } catch {
                    print("Couldnt parse JSON..")
                }
                
            }
        }

        task.resume()
    }
    
    func getCities(_ searchQuery : String, completion: @escaping( Result<[City], Error>) -> Void) {
        let baseURL: String = "http://78.71.86.80/thunbergCitiesAPI/"

        let urlString : String = baseURL + "?amountResults=10&searchQuery=\(searchQuery)"
        
        
        guard let url: URL = URL(string: urlString) else { return }

     
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let unwrappedError = error {
                completion(.failure(unwrappedError))
                return
            }
            if let unwrappedData = data {
                do {

                    let json = try JSON(data: unwrappedData)

                    let myGroup = DispatchGroup()
                    
                    var cityList : [City] = []
                    for city in json {
                        myGroup.enter()

                        let cityName = city.1["city_name"].string ?? ""
                        self.getCityInfo(cityName) { (result) in
                           switch result {
                           case .success(let cityInfo):
                               let city: City = City(cityName: cityName, cityInfo: cityInfo)
                               cityList.append(city)
                               myGroup.leave()
                           case .failure(let error): print("Error \(error)")
                           }
                       }
                    }
                    myGroup.notify(queue: .main) {
                        completion(.success(cityList))
                    }
                   
                } catch {
                    print("Couldnt parse JSON..")
                }
                
            }
        }

        task.resume()
    }
    
}


