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
  enum DetectedType: String {
    case unableToProc = "-"
    case singlePowerCube = "S"
    case doublePowerCube = "D"
    case multiplePowerCubes = "M"
  }

  static func calculateData (from rectangle: DBugRect) -> (Double, Double) {
    let type = self.getResultType(of: rectangle)
    let azimuth = self.getAzimuthAngle(for: type, with: rectangle.getCenteroid())
    let distance = self.getApproximateDistance(for: type, from: rectangle)
    return (distance: distance, azimuth: azimuth)
  }

  internal static func getResultType (of rectangle: DBugRect) -> DetectedType {
    let owidth = rectangle.angle < -45 ? rectangle.width : rectangle.height
    let oheight = rectangle.angle < -45 ? rectangle.height : rectangle.width
    let ratio = owidth / oheight

    let isSingle = ratio <= Constants.sizeConstants.singlePowerCubeRatio
    let isDouble = ratio <= Constants.sizeConstants.doublePowerCubeRatio

    if isSingle { return .singlePowerCube }
    else if isDouble { return .doublePowerCube }
    else { return .multiplePowerCubes }
  }

  internal static func getAzimuthAngle (for type: DetectedType, with centroid: DBugPoint) -> Double {
    let fov = Constants.iphone7FOV, width = Double(UIScreen.main.bounds.width)
    let ratio = self.getRatio(for: type)
    let distance = width - centroid.x

    return ratio != Double.nan
      ? ((fov * distance)) / width
      : Double.nan
  }

  internal static func getApproximateDistance (for type: DetectedType, from rectangle: DBugRect) -> Double {
    let area = self.getRectArea(rectangle, for: type)
    let pcArea = Constants.sizeConstants.powerCubeArea

    return area != Double.nan
      ? sqrt(pcArea / area)
      : Double.nan
  }

  internal static func getRectArea (_ rectangle: DBugRect, for type: DetectedType) -> Double {
    switch type {
    case .singlePowerCube: return rectangle.width * rectangle.height
    case .doublePowerCube: return (rectangle.width / 2) * rectangle.height
    default: return Double.nan
    }
  }

  internal static func getRatio (for type: DetectedType) -> Double {
    switch type {
    case .singlePowerCube: return 2.0
    case .doublePowerCube: return 4.0
    default: return Double.nan
    }
  }
}
