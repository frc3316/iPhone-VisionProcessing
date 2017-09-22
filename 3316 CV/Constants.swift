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
  static let lowerColorBound = DBugColor(hue: 40, saturation: 100, value: 30)
  static let upperColorBound = DBugColor(hue: 80, saturation: 255, value: 255)

  // Camera settings
  static let camera: CameraSettings = (
    exposure: (
      duration: 1100,
      iso: 22
    ),
    flash: false
  )

  // Rectangle manager settings
  static let scaleFactor: CGFloat = 0.53
  static let pointLayerWidth = 10
}
