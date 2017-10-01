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

  func distanceFrom (rect: DBugRect) -> Centroid {
    let centroid = rect.getCenteroid()!
    let azimuth = self.calculateHorizontalAngle(from: centroid)
    let polar = self.calculateVerticalAngle(from: centroid)
    return (
      polar: polar,
      azimuth: azimuth,
      distance: 0
    )
  }

  internal func calculateHorizontalAngle (from point: DBugPoint) -> Double {
    let fov = Constants.iphone7FOV
    let width = Double(UIScreen.main.bounds.width)
    let distance = width - point.x
    return (fov * distance) / width
  }

  internal func calculateVerticalAngle (from point: DBugPoint) -> Double {
    let fov = Constants.iphone7FOV
    let height = Double(UIScreen.main.bounds.height)
    let distance = height - point.y
    return (fov * distance) / height
  }
}
