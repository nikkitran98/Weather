import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    var iconImageView = UIImageView()
    var tempLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconImageView)
        addSubview(tempLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: HourlyWeatherEntry) {
        tempLabel.text = "\(model.temperature)"
        tempLabel.textAlignment = .center
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.image = UIImage(named: "clear")
        
        iconImageView.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), 50, 50)
        tempLabel.font = UIFont.systemFont(ofSize: 16)
        tempLabel.frame = CGRectMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(iconImageView.frame), 30, 16)
    }
}
