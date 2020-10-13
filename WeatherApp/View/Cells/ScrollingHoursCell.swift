//
//  ScrollingHoursCell.swift
//  WeatherApp
//
//  Created by kluv on 11/08/2020.
//  Copyright © 2020 com.kluv.weatherapp. All rights reserved.
//

import UIKit

class ScrollingHoursCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
        
    var weatherHours: [Hours] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

extension ScrollingHoursCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherHours.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourCell", for: indexPath) as! HourCell
        let weatherHour = weatherHours[indexPath.row]
        cell.hourLabel.text = "\(weatherHour.time):00"
        cell.tempLabel.text = "\(weatherHour.temp)C"
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        
        return cell
    }
}

extension ScrollingHoursCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}
