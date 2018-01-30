//
//  Types.swift
//  3316 CV
//
//  Created by Jonathan Ohayon on 02/09/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

import UIKit

//! Camera exposure tuple
typealias Exposure = (
  duration: Int32,
  iso: Float
)

//! Camera settings tuple
typealias CameraSettings = (
  exposure: Exposure,
  flash: Bool
)

//! Centroid info tuple
typealias Centroid = (
  distance: Double,
  angle: Double
)

//! Size manager configuration
typealias Sizes = (
  powerCubeArea: Double,
  singlePowerCubeRatio: Double,
  doublePowerCubeRatio: Double
)
