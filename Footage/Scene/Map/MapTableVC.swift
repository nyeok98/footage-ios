//
//  TableVC.swift
//  footage
//
//  Created by Wootae on 7/28/20.
//  Copyright © 2020 EL.Co. All rights reserved.
//

import UIKit
import MapKit

class MapTableVC: UIViewController {
    
    var tableView = UITableView()
    var footstepDistance: [Footstep:Double] = [:]
    var allFootsteps: [Footstep] = []
    var orderedFootsteps: [Footstep] = [] {
        didSet { M.bottomVC.resultLabel.text = "주변의 다른 발자취: " + String(orderedFootsteps.count) }
    }
    
    let distanceLimit = 10000.0
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tableView.frame = CGRect(x: 0, y: 170, width: K.screenWidth, height: K.screenHeight)
        tableView.register(MapTableCell.self, forCellReuseIdentifier: MapTableCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 70
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.allowsSelection = true
    }
    
    func reloadWithNewLocation(coordinate: CLLocationCoordinate2D, selected: Footstep?) {
        M.bottomVC.showTable()
        footstepDistance.removeAll()
        for footstep in allFootsteps {
            if footstep.timestamp == selected?.timestamp { // selected footstep must not show on the table
                continue
            }
            let distance = distanceFromPin(from: coordinate, to: footstep)
            if distance < distanceLimit {
                footstepDistance.updateValue(distance / 1000, forKey: footstep)
            }
        }
        
        orderedFootsteps = footstepDistance.keys.sorted(by: { (f1, f2) -> Bool in
            return (footstepDistance[f1]!.isLess(than: footstepDistance[f2]!))
        })
        tableView.reloadData()
    }
    
    private func distanceFromPin(from: CLLocationCoordinate2D, to: Footstep) -> Double {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return toLocation.distance(from: fromLocation)
    }
}

extension MapTableVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedFootsteps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MapTableCell.reuseIdentifier, for: indexPath) as? MapTableCell else { fatalError("Cannot create new cell") }
        cell.footstep = orderedFootsteps[indexPath.item]
        cell.distance = footstepDistance[cell.footstep] ?? 0.0
        cell.configureCell()
        return cell
    }
    
}

extension MapTableVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let footstep = orderedFootsteps[indexPath.item]
        M.mapVC.mapView.setCenter(footstep.coordinate, animated: true)
        M.bottomVC.reloadSelectedView(selected: footstep)
        tableView.deselectRow(at: indexPath, animated: true)
        reloadWithNewLocation(coordinate: footstep.coordinate, selected: footstep)
    }
    
}
