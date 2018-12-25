//
//  ViewController.swift
//  weatherappapi
//
//  Created by Student016 on 25/12/18.
//  Copyright © 2018 ra. All rights reserved.
//

import UIKit
import MapKit
//https://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=f6e23246a7dd52101e7e26230da632ae
class ViewController: UIViewController,UITextFieldDelegate {
    var lat:Double = 0.0
    var long:Double = 0.0
    @IBOutlet weak var tetfield: UITextField!
    
    
    @IBOutlet weak var temp: UILabel!
    
    @IBOutlet weak var humid: UILabel!
    
    @IBOutlet weak var press: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
   
        tetfield.delegate = self
    }
    

    @IBAction func getweathe(_ sender: UIButton) {
            parsejson()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let address = tetfield.text
        let geo  = CLGeocoder()
        geo.geocodeAddressString(address!) { (placemarks, error) in
            let placemark = placemarks?.first
            let location = placemark?.location
            let corrdinate = location?.coordinate
            self.lat = (corrdinate?.latitude)!
        
            
            self.long = (corrdinate?.longitude)!
  
        }
        return true
    }
    
    func parsejson()
    {
        let urlstr:String = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=f6e23246a7dd52101e7e26230da632ae"
    
        let url:URL = URL(string: urlstr)!
        let session:URLSession = URLSession(configuration: .default)
        let datatask = session.dataTask(with: url) { (data, response, error) in
            if response != nil
            {
                if data != nil
                {
                    do
                    {
                        let firstarry:[String:Any] = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)as![String:Any]
                        
                          let mainDic:[String:Any] = firstarry["main"] as! [String:Any]
                        
                        
                        let humidity:NSNumber = mainDic["humidity"] as! NSNumber
                        
                        
                        
                        let strhumidity:String = humidity.stringValue
                        
                        print("Got humidity:\(strhumidity)")
                        
                        let temperature:NSNumber = mainDic["temp"] as! NSNumber
                        
                        let strtemperature:String = temperature.stringValue
                        
                        print("Got temperature:\(strtemperature)")
                     
                        let pressure:NSNumber = mainDic["pressure"] as! NSNumber
                          let strpressure:String = pressure.stringValue
                        print("Got pressure:\(strpressure)")
                        DispatchQueue.main.async {
                            self.temp.text = strtemperature
                            self.press.text = strpressure
                            self.humid.text = strhumidity
                        }
                       
                        
                    }
                    catch{
                        print("\(error.localizedDescription)")
                    }
                }
                else
                {
                    print("data not found:\(error?.localizedDescription)")
                }
            }
        }
datatask.resume()
        
    }
    
    
}

