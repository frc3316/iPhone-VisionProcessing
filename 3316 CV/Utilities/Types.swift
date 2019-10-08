//
//  Types.swift
//  3316 CV
//
//  Created by Jonathan Ohayon on 02/09/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

import UIKit

//! Camera exposure tuple
typealias Exposure = Int32

//! Camera settings tuple
typealias CameraSettings = (
  exposure: Exposure,
  flash: Bool
)

//! Centroid info tuple
typealias Centroid = (
  polar: Double,
  azimuth: Double,
  distance: Double,
  isDetected: Bool
)

//! Size manager configuration
typealias Sizes = (
  powerCubeArea: Double,
  singlePowerCubeRatio: Double,
  doublePowerCubeRatio: Double
)
