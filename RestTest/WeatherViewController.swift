//
//  ViewController.swift
//  WeatherApp
//
//  Created by Omid on 23/08/2016.

import UIKit
import CoreLocation
import Alamofire 
import SwiftyJSON


class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
   // @IBOutlet weak var faren: UISwitch!
    @IBOutlet weak var texTry: UITextView!
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    
    @IBAction func `switch`(_ sender: UISwitch) {
        
        if sender.isOn {
            
        }
    }
    
    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
 
    
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!


    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
       
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
       
    
    
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getWeatherData(url: String) {
        
        Alamofire.request(url, method: .get).responseJSON { [self]
            response in
            if response.result.isSuccess {
                
                self.print("Success! Got the weather data")
                let weatherJSON : JSON = JSON(response.result.value!)
                
                
                print(weatherJSON)
             //   
                self.updateWeatherData(json: weatherJSON)
                
            }
            else {
                self.print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
        
    }
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
     
    
    
    
    //Write the updateWeatherData method here:
    
    func print(_ items: Any...) {
        //Add `items` to a text view here
        
        
        Swift.print(items)
    }
    func updateWeatherData(json : JSON) {
    
        let tempResult = json["main"]["temp"].doubleValue
    
            texTry.text = json.rawString()
        
            weatherDataModel.temperature = Int(tempResult - 273.15)
    
            weatherDataModel.city = json["origin"].stringValue
    
            weatherDataModel.condition = json["weather"][0]["id"].intValue
    
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
    
    
            updateUIWithWeatherData()
        }
    
        
//        else {
//            cityLabel.text = "Weather Unavailable"
//        }
//    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    func updateUIWithWeatherData() {
        
       // texTry.text = weatherDataModel.city
        
    }
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/

    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            
            locationManager.stopUpdatingLocation()
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL)
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
       // cityLabel.text = "Location Unavailable"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    
    
    func userEnteredANewCityName(city: String) {
        let WEATHER_URL =  city
        getWeatherData(url: WEATHER_URL)
        
    }

    
    //Write the PrepareForSegue Method here
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeCityName" {
            
            let destinationVC = segue.destination as! ChangeCityViewController
            
            
            destinationVC.delegate = self
            
        }
        
    }
    
    
}











