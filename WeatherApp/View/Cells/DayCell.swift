//
//  DayCell.swift
//  WeatherApp
//
//  Created by kluv on 11/08/2020.
//  Copyright © 2020 com.kluv.weatherapp. All rights reserved.
//

import UIKit

class DayCell: UITableViewCell {

    @IBOutlet weak var dayWeekLabel: UILabel!
    @IBOutlet weak var dayTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
