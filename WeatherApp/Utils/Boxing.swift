//
//  Boxing.swift
//  WeatherApp
//
//  Created by kluv on 19/08/2020.
//  Copyright © 2020 com.kluv.weatherapp. All rights reserved.
//

import Foundation

final class Boxing<T> {
  
  typealias Listener = (T) -> Void
  var listener: Listener?
  
  var value: T {
    didSet {
      listener?(value)
    }
  }
  
  init(_ value: T) {
    self.value = value
  }
  
  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}
