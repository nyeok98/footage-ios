//
//  Report.swift
//  footage
//
//  Created by 녘 on 2020/07/14.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit

class ReportVC: UIViewController {
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var januaryButton: UIButton!
    @IBOutlet weak var februaryButton: UIButton!
    @IBOutlet weak var marchButton: UIButton!
    @IBOutlet weak var aprilButton: UIButton!
    @IBOutlet weak var mayButton: UIButton!
    @IBOutlet weak var juneButton: UIButton!
    @IBOutlet weak var julyButton: UIButton!
    @IBOutlet weak var augustButton: UIButton!
    @IBOutlet weak var septemberButton: UIButton!
    @IBOutlet weak var octoberButton: UIButton!
    @IBOutlet weak var novemberButton: UIButton!
    @IBOutlet weak var decemberButton: UIButton!
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToReportDetail", sender: sender)
    }
    
    
    var colorRank: Array<(key: String, value: Double)> = []
    var placeRank: Array<(key: String, value: Double)> = []
    var startDate: Int?
    var endDate: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtons()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ReportDetailVC
        guard let selectedButton = sender as? UIButton else { return }
        setStartEndDate(tag: selectedButton.tag)
        destinationVC.whichMonth = String(selectedButton.tag)
        destinationVC.colorRanking = ColorManager.getRankingDistance(startDate: startDate!, endDate: endDate!)
        destinationVC.placeRanking = PlaceManager.getRankingDistance(startDate: startDate!, endDate: endDate!)
    }
    
    func setButtons() {
        let monthButtonList = [januaryButton, februaryButton, marchButton, aprilButton, mayButton, juneButton, julyButton, augustButton, septemberButton, octoberButton, novemberButton, decemberButton]
        for index in 0...11 {
            setStartEndDate(tag: (index+1))
            if ColorManager.getRankingDistance(startDate: startDate!, endDate: endDate!).isEmpty {
                monthButtonList[index]!.isEnabled = false
                monthButtonList[index]!.alpha = 0.1
            } else {
                monthButtonList[index]!.isEnabled = true
                monthButtonList[index]!.alpha = 1
            }
            
        }
    }
    
    func setStartEndDate(tag: Int) {
        startDate = DateConverter.tagToMonth(year: 2020, tag: tag, start: true)
        endDate = DateConverter.tagToMonth(year: 2020, tag: tag, start: false)
    }
}
