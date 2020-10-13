//
//  ViewController.swift
//  WeatherApp
//
//  Created by kluv on 05/08/2020.
//  Copyright © 2020 com.kluv.weatherapp. All rights reserved.
//

import UIKit

protocol ViewControllerDelegate {
    func toggleMenu()
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = WeatherViewModel()
    private var weatherDays: [Days] = []
    private var weatherHours: [Hours] = []
    private var cityName: String = ""
    
    var delegate: ViewControllerDelegate?
    
    private let menuButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "menu"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar: UINavigationBar = self.navigationController!.navigationBar
        
        navBar.standardAppearance.backgroundColor = UIColor.clear
        navBar.standardAppearance.backgroundEffect = nil
        navBar.standardAppearance.shadowImage = UIImage()
        navBar.standardAppearance.shadowColor = .clear
        navBar.standardAppearance.backgroundImage = UIImage()
        
        menuButton.addTarget(self, action: #selector(menuAction(sender:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
         
        viewModel.cityName.bind { [weak self] cityName in
            self?.cityName = cityName
        }
        
        viewModel.forecast.bind { [weak self] forecast in
            self?.weatherDays = forecast.weatherDays
            self?.weatherHours = forecast.weatherHours
            self?.tableView.reloadData()
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let statusBarHeight = getStatusBarHeight()
        tableView.contentInset = UIEdgeInsets(top: -(statusBarHeight + (navigationController?.navigationBar.bounds.height ?? 0)) , left: 0, bottom: 0, right: 0)
    }
    
    private struct Cells {
        static let mainCell = "MainCell"
        static let hoursCell = "HoursCell"
        static let dayCell = "DayCell"
    }

    func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            statusBarHeight = UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    //MARK: Actions
    @objc func menuAction(sender: UIBarButtonItem) {
        delegate?.toggleMenu()
    }
    
}

//
// MARK: - Table View Data Source
//
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if weatherDays.count == 0 {
            if indexPath.row == 0 {
                let itemCell = tableView.dequeueReusableCell(withIdentifier: Cells.mainCell, for: indexPath) as! MainScreenCell
                itemCell.infoLabel.text = "- -"
                cell = itemCell
            } else if indexPath.row == 1 {
                let itemCell = tableView.dequeueReusableCell(withIdentifier: Cells.hoursCell, for: indexPath) as! ScrollingHoursCell
                cell = itemCell
            } else if indexPath.row > 1 {
                let itemCell = tableView.dequeueReusableCell(withIdentifier: Cells.dayCell, for: indexPath) as! DayCell
                itemCell.dayWeekLabel.text = "- -"
                itemCell.dayTempLabel.text = "- -"
                cell = itemCell
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "staticCell")!
            }
        } else {
            if indexPath.row == 0 {
                let itemCell = tableView.dequeueReusableCell(withIdentifier: Cells.mainCell, for: indexPath) as! MainScreenCell
                let weatherDay = weatherDays[indexPath.row]
                itemCell.infoLabel.text = "\(cityName), \n\(weatherDay.dayOfWeek)\n\(weatherDay.temp) C"
                cell = itemCell
            } else if indexPath.row == 1 {
                let itemCell = tableView.dequeueReusableCell(withIdentifier: Cells.hoursCell, for: indexPath) as! ScrollingHoursCell
                itemCell.weatherHours = weatherHours
                cell = itemCell
            } else if indexPath.row > 1 {
                let itemCell = tableView.dequeueReusableCell(withIdentifier: Cells.dayCell, for: indexPath) as! DayCell
                let weatherDay = weatherDays[indexPath.row-1]
                itemCell.dayWeekLabel.text = weatherDay.dayOfWeek
                itemCell.dayTempLabel.text = "\(weatherDay.tempString)C"
                cell = itemCell
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "staticCell")!
            }
        }

        return cell
    }
    
}
