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
  static let lowerColorBound = DBugColor(hue: 20, saturation: 120, value: 100)
  static let upperColorBound = DBugColor(hue: 80, saturation: 255, value: 255)

  // Camera settings
  static let camera: CameraSettings = (
    exposure: 25,
    flash: true
  )

  // Taken from https://goo.gl/Nq92tY
  static let iphone7FOV = 59.680

  // Rectangle manager settings
  static let scaleFactor = 0.53
  static let pointLayerWidth = 10

  static let sizeConstants: Sizes = (
    powerCubeArea: 13600,
    singlePowerCubeRatio: 1.5,
    doublePowerCubeRatio: 2.5
  )
}
