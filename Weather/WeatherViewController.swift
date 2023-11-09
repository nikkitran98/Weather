import UIKit
import CoreLocation

private let reuseIdentifier = "Cell"
private let weatherReuseIdentifier = "weather-cell"
private let hourlyReuseIdentifer = "hourly-cell"

class WeatherViewController: UIViewController {
    var tableView = UITableView()
    var models = [DailyWeatherEntry]()
    var hourlyModels = [HourlyWeatherEntry]()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var currentWeather: CurrentWeather?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        tableView.rowHeight = 75
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: weatherReuseIdentifier)
        tableView.register(HourlyTableViewCell.self, forCellReuseIdentifier: hourlyReuseIdentifer)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else { return }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        let url = "https://api.pirateweather.net/forecast/OvcQkv4DXcU2X4JYZIIAIFqnJe6o3qvu/\(lat),\(long)"
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            // validation
            if let error = error {
                print(error)
            } else if let data = data {
                // convert data to models / decode
                var json: WeatherResponse?
                do {
                    json = try JSONDecoder().decode(WeatherResponse.self, from: data)
                } catch {
                    print("Error: \(error)")
                }
                
                guard let result = json else { return }
                
                let entries = result.daily.data
                
                self.models.append(contentsOf: entries)
                
                let current = result.currently
                self.currentWeather = current
                
                self.hourlyModels = result.hourly.data
                
                // update user interface
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.tableHeaderView = self.createTableHeader()
                }
            }
        }).resume()
        
        print("\(long) | \(lat)")
    }
    
    func createTableHeader() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        headerView.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        let locationLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width-20, height: headerView.frame.size.height / 5))
        let summaryLabel = UILabel(frame: CGRect(x: 10, y: 20 + locationLabel.frame.size.height, width: view.frame.size.width-20, height: headerView.frame.size.height / 5))
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 20 + summaryLabel.frame.size.height, width: view.frame.size.width-20, height: headerView.frame.size.height / 2))
        
        headerView.addSubview(locationLabel)
        headerView.addSubview(summaryLabel)
        headerView.addSubview(tempLabel)
        tempLabel.textAlignment = .center
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 32)
        locationLabel.textAlignment = .center
        summaryLabel.textAlignment = .center
        
        guard let currentWeather = self.currentWeather else { return UIView() }
        summaryLabel.text = "\(currentWeather.summary)°"
        tempLabel.text = "\(currentWeather.temperature)°"
        locationLabel.text = "Current Location"

        return headerView
    }
    
}

// MARK: - CoreLocation

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
}

// MARK: - UITableViewDelegate/UITableViewDataSource

extension WeatherViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return models.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: hourlyReuseIdentifer, for: indexPath) as! HourlyTableViewCell
            cell.configure(with: hourlyModels)
            cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: weatherReuseIdentifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: models[indexPath.row])
        cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        return cell
    }
}

struct WeatherResponse: Codable {
    let latitude: Float
    let longitude: Float
    let timezone: String
    let currently: CurrentWeather
    let hourly: HourlyWeather
    let daily: DailyWeather
    let offset: Float
}

struct CurrentWeather: Codable {
    let time: Int
    let summary: String
    let icon: String
    let nearestStormDistance: Int
    let nearestStormBearing: Int
    let precipIntensity: Double
    let precipProbability: Double
    let temperature: Double
    let apparentTemperature: Double
    let dewPoint: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windGust: Double
    let windBearing: Double
    let cloudCover: Double
    let uvIndex: Double
    let visibility: Double
    let ozone: Double
}

struct DailyWeather: Codable {
    let summary: String
    let icon: String
    let data: [DailyWeatherEntry]
}

struct DailyWeatherEntry: Codable {
    let time: Int
    let summary: String
    let icon: String
    let sunriseTime: Int
    let sunsetTime: Int
    let moonPhase: Double
    let precipIntensity: Float
    let precipIntensityMax: Float
    let precipIntensityMaxTime: Int
    let precipProbability: Double
    let precipType: String?
    let temperatureHigh: Double
    let temperatureHighTime: Int
    let temperatureLow: Double
    let temperatureLowTime: Int
    let apparentTemperatureHigh: Double
    let apparentTemperatureHighTime: Int
    let apparentTemperatureLow: Double
    let apparentTemperatureLowTime: Int
    let dewPoint: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windGust: Double
    let windGustTime: Int
    let windBearing: Double
    let cloudCover: Double
    let uvIndex: Double
    let uvIndexTime: Int
    let visibility: Double
    let temperatureMin: Double
    let temperatureMinTime: Int
    let temperatureMax: Double
    let temperatureMaxTime: Int
    let apparentTemperatureMin: Double
    let apparentTemperatureMinTime: Int
    let apparentTemperatureMax: Double
    let apparentTemperatureMaxTime: Int
}

struct HourlyWeather: Codable {
    let summary: String
    let icon: String
    let data: [HourlyWeatherEntry]
}

struct HourlyWeatherEntry: Codable {
    let time: Int
    let summary: String
    let icon: String
    let precipIntensity: Float
    let precipProbability: Double
    let precipType: String?
    let temperature: Double
    let apparentTemperature: Double
    let dewPoint: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windGust: Double
    let windBearing: Double
    let cloudCover: Double
    let uvIndex: Double
    let visibility: Double
    let ozone: Double
}
