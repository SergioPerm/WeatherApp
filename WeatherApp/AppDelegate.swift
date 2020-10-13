//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by kluv on 05/08/2020.
//  Copyright © 2020 com.kluv.weatherapp. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = ContainerViewController()
        
        return true
    }


}

