//
//  TableViewControllerStartscreen.swift
//  SwiftLabb1
//
//  Created by Jonathan Thunberg on 2020-02-03.
//  Copyright © 2020 Jonathan Thunberg. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

var cityResultArrayFromAPI : [City] = []
var cityResultArray : [City] = []

class TableViewCellStartscreen : UITableViewCell {
    
    
    
    @IBOutlet weak var weatherBoxTable: UIView!
    @IBOutlet weak var CityNameTableViewUI: UILabel!
    @IBOutlet weak var CityTempTableViewUI: UILabel!
    @IBOutlet weak var CityImageTableViewUI: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.weatherBoxTable.layer.cornerRadius = 5;
        self.weatherBoxTable.layer.masksToBounds = true;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}




var userCurrentLocation = (0.00, 0.00)

class TableViewControllerStartscreen: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UISearchBarDelegate {
    
       
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cityNameCurrentUI: UILabel!
    @IBOutlet weak var cityTempCurrentUI: UILabel!
    @IBOutlet weak var cityIconImageUI: UIImageView!
    

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var weatherBox: UIView!
    
    
    
    var isSearching : Bool = false
    var usingArray : [City] = []

  
    override func viewDidLoad() {
            super.viewDidLoad()

            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        
        
            self.tableView.separatorStyle = .none
            self.weatherBox.layer.cornerRadius = 5;
            self.weatherBox.layer.masksToBounds = true;
        
            UIView.animate(withDuration: 2) {
                self.weatherBox.frame.size.width *= 1.25
            }

            tableView.delegate = self
            tableView.dataSource = self
        
            let citiesApi = CitiesAPI();
        
            citiesApi.getCities("") { (result) in
                switch result {
                case .success(let cityList):
                    DispatchQueue.main.async {
                        cityResultArrayFromAPI = cityList
                        
                      
                        self.usingArray = cityResultArrayFromAPI
                         
                        self.tableView.reloadData()

                        
                    }
                case .failure(let error): print("Error \(error)")
                }
            }
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        cityResultArray = cityResultArrayFromAPI.filter({ $0.cityName.lowercased().contains(searchText.lowercased()) })
        
        
        if (searchText == "") {
            isSearching = false
            cityResultArray = cityResultArrayFromAPI
        } else {
            isSearching = true
        }
        
        
        if (cityResultArray.count == 0) {
            
            print("Researching...")
            let citiesApi = CitiesAPI();

            citiesApi.getCities(searchText) { (result) in
                switch result {
                case .success(let cityList):
                    DispatchQueue.main.async {
                        cityResultArrayFromAPI = cityList
                        
                      
                        self.usingArray = cityResultArrayFromAPI
                         
                        self.tableView.reloadData()

                        
                    }
                case .failure(let error): print("Error \(error)")
                }
            }
        }
        
        
        usingArray = cityResultArray
        tableView.reloadData()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let long = location.coordinate.longitude
        let lat = location.coordinate.latitude
        userCurrentLocation = (lat, long)
        
        updateCurrentLocation()
        
        
    }
    
    func updateCurrentLocation() {
        let citiesApi = CitiesAPI()
        
        citiesApi.getClosestCity(userCurrentLocation.0, userCurrentLocation.1){ (result) in
            switch result {
            case .success(let city):
                DispatchQueue.main.async {
                    self.cityNameCurrentUI.text = city.cityName
                    self.cityTempCurrentUI.text = String("\(city.cityInfo.temp) °C")
                
                    guard let url = URL(string: "https://openweathermap.org/img/wn/\(city.cityInfo.iconId)@2x.png") else { return }
                    let data = try? Data(contentsOf: url)
                    self.cityIconImageUI.image = UIImage(data: data!)
                }
            case .failure(let error): print("Error \(error)")
            }
        }
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usingArray.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

       
        let cell : TableViewCellStartscreen = self.tableView.dequeueReusableCell(withIdentifier: "tableCellStartscreen") as! TableViewCellStartscreen
            
        cell.selectionStyle = UITableViewCell.SelectionStyle.none

            
        cell.CityNameTableViewUI.text = String(usingArray[indexPath.row].cityName)
        if (usingArray[indexPath.row].cityInfo.temp == -273) {
            cell.CityTempTableViewUI.text = String("No data for this city")
        } else {
            cell.CityTempTableViewUI.text = String("\(usingArray[indexPath.row].cityInfo.temp) °C")
        }


        var image : UIImage = UIImage(named: "noimage.png")!
        
        if (usingArray[indexPath.row].cityInfo.iconId != "") {
            let url = URL(string: "https://openweathermap.org/img/wn/\(usingArray[indexPath.row].cityInfo.iconId)@2x.png")!
            let data = try? Data(contentsOf: url)
            image = UIImage(data: data!)!
        } else {
            
        }
               
            
        cell.CityImageTableViewUI.image = image

            
        
        
        return cell
    }


    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewControllerCityInfo") as! ViewControllerCityInfo
        vc.city = usingArray[indexPath.row].cityName
        vc.weatherStatus = usingArray[indexPath.row].cityInfo.weatherStatus
        vc.temp = usingArray[indexPath.row].cityInfo.temp
        
        self.navigationController?.pushViewController(vc, animated:true)
     
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0;
    }


}


