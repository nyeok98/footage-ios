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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        januaryButton.isEnabled = false
        let days = DateConverter.lastMondayToday()
        colorRank = ColorManager.getRankingDistance(startDate: days.0, endDate: days.1)
        placeRank = PlaceManager.getRankingDistance(startDate: days.0, endDate: days.1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ReportDetailVC
        guard let selectedButton = sender as? UIButton else { return }
        let startDate = DateConverter.tagToMonth(year: 2020, tag: selectedButton.tag, start: true)
        let endDate = DateConverter.tagToMonth(year: 2020, tag: selectedButton.tag, start: false)
        destinationVC.whichMonth = String(selectedButton.tag)
        destinationVC.colorRanking = ColorManager.getRankingDistance(startDate: startDate, endDate: endDate)
        destinationVC.placeRanking = PlaceManager.getRankingDistance(startDate: startDate, endDate: endDate)
    }
}
