import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    var dayLabel = UILabel()
    var lowTempLabel = UILabel()
    var highTempLabel = UILabel()
    var iconImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .gray
        dayLabel.numberOfLines = 0
        iconImageView.contentMode = .scaleAspectFit
        lowTempLabel.numberOfLines = 0
        highTempLabel.numberOfLines = 0
        
        addSubview(dayLabel)
        addSubview(iconImageView)
        addSubview(lowTempLabel)
        addSubview(highTempLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: DailyWeatherEntry) {
        dayLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(model.time)))
        lowTempLabel.text = "\(Int(model.temperatureLow))°"
        highTempLabel.text = "\(Int(model.temperatureHigh))°"
        
        let icon = model.icon.lowercased()
        if icon.contains("clear") {
            iconImageView.image = UIImage(named: "clear")
        } else if icon.contains("rain") {
            iconImageView.image = UIImage(named: "rain")
        } else {
            iconImageView.image = UIImage(named: "cloud")
        }
        
        dayLabel.font = UIFont.systemFont(ofSize: 16)
        dayLabel.frame = CGRectMake(CGRectGetMinX(self.bounds) + 10, CGRectGetMidY(self.bounds), 75, 16)
        
        iconImageView.frame = CGRectMake(CGRectGetMaxX(dayLabel.frame) + 20, CGRectGetMidY(self.bounds), 50, 50)
        
        lowTempLabel.font = UIFont.systemFont(ofSize: 16)
        lowTempLabel.frame = CGRectMake(CGRectGetMaxX(iconImageView.frame) + 20, CGRectGetMidY(self.bounds), 50, 16)
        
        highTempLabel.font = UIFont.systemFont(ofSize: 16)
        highTempLabel.frame = CGRectMake(CGRectGetMaxX(lowTempLabel.frame) + 20, CGRectGetMidY(self.bounds), 50, 16)
    }
    
    func getDayForDate(_ date: Date?) -> String {
        guard let inputDate = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Day of the week
        return formatter.string(from: inputDate)
    }

}
