//
//  Types.swift
//  3316 CV
//
//  Created by Jonathan Ohayon on 02/09/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

import UIKit
import Vision

typealias DetectionHandler = ([CGPoint]) -> Void
typealias Calibration = (
  start: (@escaping DetectionHandler) -> Void,
  stop: () -> Void,
  observation: VNRectangleObservation?
)
typealias Tracker = (start: () -> Void, stop: () -> Void)

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
