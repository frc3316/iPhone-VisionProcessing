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
  // Network manager configuration
  static let teamNumber = 3316
  static let roborioPort: UInt16 = 8000

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

  // Taken from https://goo.gl/Nq92tY + caclulations
  static let i7FOVx = 59.68
  static let i7FOVy = 33.57

  // Rectangle manager settings
  static let scaleFactor = 0.53
  static let pointLayerWidth = 10

  static let goalMeasures: Measures = (
    width: 0,
    height: 0
  )

  static let emptyCentroid: Centroid = (
    distance: -1,
    polar: -1,
    azimuth: -1,
    isDetected: false
  )
}
