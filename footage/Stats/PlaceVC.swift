//
//  PlaceVC.swift
//  footage
//
//  Created by 녘 on 2020/06/30.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import EFCountingLabel

class PlaceVC: UIViewController {
    // for layout
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var firstContent: UIView!
    @IBOutlet weak var secondContent: UIView!
    @IBOutlet weak var thirdContent: UIView!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var firstStack: UIStackView!
    @IBOutlet weak var secondStack: UIStackView!
    @IBOutlet weak var thirdStack: UIStackView!
    // for displaying data
    @IBOutlet weak var firstMap: UIImageView!
    @IBOutlet weak var firstDistance: EFCountingLabel!
    @IBOutlet weak var secondMap: UIImageView!
    @IBOutlet weak var secondDistance: EFCountingLabel!
    @IBOutlet weak var thirdMap: UIImageView!
    @IBOutlet weak var thirdDistance: EFCountingLabel!
    @IBOutlet weak var firstCityName: UILabel!
    @IBOutlet weak var secondCityName: UILabel!
    @IBOutlet weak var thirdCityName: UILabel!
    var ranking: Array<(key: String, value: Double)> = []
    
    @IBAction func goBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        secondButton.setImage(#imageLiteral(resourceName: "placeSection"), for: .normal)
        secondContent.alpha = 0
        thirdButton.setImage(#imageLiteral(resourceName: "placeSection"), for: .normal)
        thirdContent.alpha = 0
        PlaceAnimation.firstIsLarge(placeVC: self)
        firstStack.bounds.origin.x -= 30
        secondStack.bounds.origin.x -= 30
        thirdStack.bounds.origin.x -= 30
        firstStack.bounds.origin.y -= 20
        secondStack.bounds.origin.y -= 20
        thirdStack.bounds.origin.y -= 20
        setDefaultData()
        loadData()
        firstButton.isUserInteractionEnabled = true
        secondButton.isUserInteractionEnabled = true
        thirdButton.isUserInteractionEnabled = true
    }
    
    @IBAction func firstplaceButtonPressed(_ sender: UIButton) {
        PlaceAnimation.firstIsLarge(placeVC: self)
    }
    @IBAction func secondplaceButtonPressed(_ sender: UIButton) {
        PlaceAnimation.secondIsLarge(placeVC: self)
    }
    @IBAction func thirdplaceButtonPressed(_ sender: UIButton) {
        PlaceAnimation.thirdIsLarge(placeVC: self)
    }
    
    func loadData() {
        if ranking.count > 0 {
            firstMap.image = getCityImage(name: ranking[0].key.components(separatedBy: " / ").first!)
            firstDistance.text = String(format: "%.2f", (ranking[0].value) / 1000)
            firstCityName.text = ranking[0].key // "서울특별시 / 동작구"
        }
        if ranking.count > 1 {
            secondMap.image = getCityImage(name: ranking[1].key.components(separatedBy: " / ").first!)
            secondDistance.text = String(format: "%.2f", (ranking[1].value) / 1000)
            secondCityName.text = ranking[1].key // "서울특별시 / 동작구"
        }
        if ranking.count > 2 {
            thirdMap.image = getCityImage(name: ranking[2].key.components(separatedBy: " / ").first!)
            thirdDistance.text = String(format: "%.2f", (ranking[2].value) / 1000)
            thirdCityName.text = ranking[2].key // "서울특별시 / 동작구"
        }
    }
    
    func getCityImage(name: String) -> UIImage? {
        switch name {
        case "서울특별시", "Seoul":
            return UIImage(named: "Seoul")
        case "세종특별자치시", "Sejong City":
            return UIImage(named: "Sejong City")
        case "제주도", "Jeju":
            return UIImage(named: "Jeju")
        case "경기도", "Gyeonggi-do":
            return UIImage(named: "Gyeonggi-do")
        case "대전광역시", "Daejeon":
            return UIImage(named: "Daejeon")
        case "울산광역시", "Ulsan":
            return UIImage(named: "Ulsan")
        case "광주광역시", "Gwangju":
            return UIImage(named: "Gwangju")
        case "부산광역시", "Busan":
            return UIImage(named: "Busan")
        case "대구광역시", "Daegu":
            return UIImage(named: "Daegu")
        case "강원도", "Gangwon":
            return UIImage(named: "Gangwon")
        case "인천광역시", "Incheon":
            return UIImage(named: "Incheon")
        case "충청북도", "North Chungcheong":
            return UIImage(named: "North Chungcheong")
        case "경상북도", "North Gyeongsang":
            return UIImage(named: "North Gyeongsang")
        case "전라북도", "North Jeolla":
            return UIImage(named: "North Jeolla")
        case "충청남도", "South Chungcheong":
            return UIImage(named: "South Chungcheong")
        case "경상남도", "South Gyeongsang":
            return UIImage(named: "South Gyeongsang")
        case "전라남도", "South Jeolla":
            return UIImage(named: "South Jeolla")
        default:
            return UIImage(named: "noDataImage")
        }
        
    }
    
    func setDefaultData() {
        firstMap.image = UIImage(named: "noDataImage")
        secondMap.image = UIImage(named: "noDataImage")
        thirdMap.image = UIImage(named: "noDataImage")
        firstDistance.text = "-"
        firstCityName.text = "-"
        secondDistance.text = "-"
        secondCityName.text = "-"
        thirdDistance.text = "-"
        thirdCityName.text = "-"
    }
    
}
