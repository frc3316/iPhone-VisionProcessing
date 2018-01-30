//
//  SizeManager.swift
//  3316 CV
//
//  Created by Jonathan Ohayon on 24/09/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

import Foundation

//! A class to manage the virtual vs irl sizes of objects
class SizeManager {
  let goalMeasures: Measures

  init (measures: Measures) {
    self.goalMeasures = measures
  }

  func distanceFrom (rect: Rectangle) -> Centroid {
    let centroid = rect.getCentroid()
    let azimuth = self.calculateAngle(
      coord: Double(centroid.x),
      width: UIScreen.main.bounds.width,
      fov: Constants.i7FOVx
    )

    let polar = self.calculateAngle(
      coord: Double(centroid.y),
      width: UIScreen.main.bounds.height,
      fov: Constants.i7FOVy
    )

    return (
      polar: polar,
      azimuth: azimuth,
      distance: 0,
      isDetected: true
    )
  }

  internal func calculateAngle (coord: Double, width: CGFloat, fov: Double) -> Double {
    let w = Double(width)
    let distance = w - coord
    return (fov * distance) / w
  }

  internal func calculateDistance (from rect: Rectangle) -> Double {
    // TODO
    return 0.0
  }
}
