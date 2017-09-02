//
//  Constants.swift
//  3316 CV
//
//  Created by Jonathan Ohayon on 30/08/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

import Foundation

//! Constant global values
struct Constants {
  // Color filter configurations
  static let lowerColorBound = DBugColor(hue: 67, saturation: 160, value: 170)
  static let upperColorBound = DBugColor(hue: 97, saturation: 255, value: 255)

  // Camera settings
  static let camera: CameraSettings = (
    brightness: 0.01,
    saturation: 1,
    exposure: 0.9,
    contrast: 0.01,
    flash: false
  )
}
