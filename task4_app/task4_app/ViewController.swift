//
//  ViewController.swift
//  task4_app
//
//  Created by Gizem Duman on 31.08.2023.
//

import UIKit
import TinyConstraints
import Kingfisher
import CoreLocation

class ViewController: UIViewController {
    
    var responseData: WeatherResponse? {
        didSet {
            configureContents()
        }
    }
    
    var locationManager: CLLocationManager!
    
    private lazy var cityName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private lazy var maxMinLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}

// MARK: UILayout
extension ViewController {
    private func addSubviews() {
        addCityLabel()
        addImageView()
        addTemperatureLabel()
        addMaxMinLabel()
    }
    
    private func addCityLabel() {
        view.addSubview(cityName)
        cityName.centerXToSuperview()
        cityName.topToSuperview(offset: 8, usingSafeArea: true)
    }
    
    private func addImageView() {
        view.addSubview(imageView)
        imageView.topToBottom(of: cityName, offset: 8)
        imageView.width(80)
        imageView.height(80)
        imageView.centerXToSuperview()
    }
    
    private func addTemperatureLabel() {
        view.addSubview(temperatureLabel)
        temperatureLabel.centerXToSuperview()
        temperatureLabel.topToBottom(of: imageView, offset: 8)
    }
    
    private func addMaxMinLabel() {
        view.addSubview(maxMinLabel)
        maxMinLabel.centerXToSuperview()
        maxMinLabel.topToBottom(of: temperatureLabel, offset: 8)
    }
}

// MARK: ConfigureContents
extension ViewController {
    private func configureContents() {
        DispatchQueue.main.async {
            self.cityName.text = self.responseData?.name
            if let code = self.responseData?.weather?.first?.icon, let url = URL(string: "https://openweathermap.org/img/w/\(code).png") {
                self.imageView.kf.setImage(with: url)
            }
            
            if let main = self.responseData?.main, let temperature = main.temp,  let maxTemperatureInCelsius = self.responseData?.main?.tempMax, let minTemperatureInCelsius = self.responseData?.main?.tempMin  {
                let temperatureInCelsius = temperature - 273.15
                let formattedTemperature = String(format: "%.0f°C", temperatureInCelsius)
                self.temperatureLabel.text = formattedTemperature
                
                let max = maxTemperatureInCelsius - 273.15
                let formattedMaxTemperature = String(format: "Max: %.0f°C", max)
                
                let min = minTemperatureInCelsius - 273.15
                let formattedMinTemperature = String(format: "Min: %.0f°C", min)
                self.maxMinLabel.text = "\(formattedMinTemperature)\(formattedMaxTemperature)"
            } else {
                self.temperatureLabel.text = "N/A"
            }
        }
    }
}

// MARK: Request
extension ViewController {
    
    func fetchWeatherData(city: String) {
        let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
        let apiKey = "84c2ed239376840962a7536a17733013"
        
        let urlString = "\(baseUrl)?q=\(city)&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                    self.responseData = weatherResponse
                } catch {
                    print("JSON parsing error: \(error)")
                }
            }
        }
        
        task.resume()
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: latitude, longitude: longitude)
            
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print("Geocoding error: \(error)")
                    return
                }
                
                if let placemark = placemarks?.first {
                    if let city = placemark.locality {
                        self.fetchWeatherData(city: city)
                    } else {
                        print("City information not available")
                    }
                }
            }
            
        }
    }
}
