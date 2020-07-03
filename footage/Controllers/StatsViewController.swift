

import UIKit
import EFCountingLabel

class StatsViewController: UIViewController {
    
    @IBOutlet weak var cityNickName: UILabel!
    var temporaryCityName: String = "세종특별자치시"
    
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var totalDistance: EFCountingLabel!
    
    override func viewDidLoad() {
        self.totalDistance.setUpdateBlock { (value, label) in
            label.text = String(format: "%.f", value)
        }
        self.totalDistance.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 7)
        self.totalDistance.countFrom(0, to: CGFloat(HomeViewController.distanceTotal / 1000), withDuration: 5)
        citySetter()
    }
    
    
    
    func citySetter() {
        switch temporaryCityName {
        case "서울특별시", "Seoul":
            cityImage.image = UIImage(named: "Seoul")
            cityNickName.text = "\"프로서울러\""
        case "세종특별자치시", "Sejong City":
            cityImage.image = UIImage(named: "Sejong City")
            cityNickName.text = "\"프로세종러\""
        case "제주도", "Jeju":
            cityImage.image = UIImage(named: "Jeju")
            cityNickName.text = "\"프로제주러\""
        case "경기도", "Gyeonggi-do":
            cityImage.image = UIImage(named: "Gyeonggi-do")
            cityNickName.text = "\"프로경기러\""
        case "대전광역시", "Daejeon":
            cityImage.image = UIImage(named: "Daejeon")
            cityNickName.text = "\"프로대전러\""
        case "울산광역시", "Ulsan":
            cityImage.image = UIImage(named: "Ulsan")
            cityNickName.text = "\"프로울산러\""
        case "광주광역시", "Gwangju":
            cityImage.image = UIImage(named: "Gwangju")
            cityNickName.text = "\"프로광주러\""
        case "부산광역시", "Busan":
            cityImage.image = UIImage(named: "Busan")
            cityNickName.text = "\"프로부산러\""
        case "대구광역시", "Daegu":
            cityImage.image = UIImage(named: "Daegu")
            cityNickName.text = "\"프로대구러\""
        case "강원도", "Gangwon":
            cityImage.image = UIImage(named: "Gangwon")
            cityNickName.text = "\"프로강원러\""
        case "인천광역시", "Incheon":
            cityImage.image = UIImage(named: "Incheon")
            cityNickName.text = "\"프로인천러\""
        case "충청북도", "North Chungcheong":
            cityImage.image = UIImage(named: "North Chungcheong")
            cityNickName.text = "\"프로충북러\""
        case "경상북도", "North Gyeongsang":
            cityImage.image = UIImage(named: "North Gyeongsang")
            cityNickName.text = "\"프로경북러\""
        case "전라북도", "North Jeolla":
            cityImage.image = UIImage(named: "North Jeolla")
            cityNickName.text = "\"프로전북러\""
        case "충청남도", "South Chungcheong":
            cityImage.image = UIImage(named: "South Chungcheong")
            cityNickName.text = "\"프로충남러\""
        case "경상남도", "South Gyeongsang":
            cityImage.image = UIImage(named: "South Gyeongsang")
            cityNickName.text = "\"프로경남러\""
        case "전라남도", "South Jeolla":
            cityImage.image = UIImage(named: "South Jeolla")
            cityNickName.text = "\"프로전남러\""
        default:
            cityImage.image = UIImage(named: "Sejong City")
            cityNickName.text = "\"프로세종러\""
        }
        
    }
    
}
