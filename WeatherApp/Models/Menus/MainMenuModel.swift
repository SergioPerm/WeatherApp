//
//  File.swift
//  WeatherApp
//
//  Created by kluv on 13/08/2020.
//  Copyright © 2020 com.kluv.weatherapp. All rights reserved.
//

import Foundation
import UIKit

enum MainMenuModel: Int, CustomStringConvertible, CaseIterable {
    
    case Perm
    case Moscow
    case Sochi
    case NewYork
    case Settings
    case About
    
    var description: String {
        switch self {
        case .Perm: return "Perm"
        case .Moscow: return "Moscow"
        case .Sochi: return "Sochi"
        case .NewYork: return "New york"
        case .Settings: return "Settings"
        case .About: return "About Us"
        }
    }
    
    var image: UIImage {
        switch self {
            case .Perm: return UIImage(named: "city") ?? UIImage()
            case .Moscow: return UIImage(named: "city") ?? UIImage()
            case .Sochi: return UIImage(named: "city") ?? UIImage()
            case .NewYork: return UIImage(named: "city") ?? UIImage()
            case .Settings: return UIImage(named: "settings") ?? UIImage()
            case .About: return UIImage(named: "about") ?? UIImage()
        }
    }
    
    
    
    
}
