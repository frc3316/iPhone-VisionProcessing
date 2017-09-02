//
//  RectManager.swift
//  3316 CV
//
//  Created by Jonathan Ohayon on 13/08/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

import AVFoundation
import Vision
import UIKit

class DetectionManager {
  internal var requests: [VNRequest] = []
  internal var lastObservation: VNRectangleObservation?

  internal var rectPoints: [CGPoint]

  var calibration: Calibration {
    return (
      start: self.startCalibration,
      stop: self.stopCalibration,
      observation: self.lastObservation
    )
  }

  /**
   * Initializes an empty DetectionManager instance
   */
  init () {
    self.rectPoints = []
  }

  /**
   * A method for starting the calibration process.
   * - parameter onRectDetected: The callback that's being called everytime a rectangle is detected with its
                                 corners as the only parameter.
   */
  internal func startCalibration (onRectDetected: @escaping DetectionHandler) {
    let rectReq = VNDetectRectanglesRequest { (req, err) in
      if let err = err { print(err.localizedDescription) }

      guard let rect = req.results?.first as? VNRectangleObservation else {
        return onRectDetected([] as [CGPoint])
      }

      DispatchQueue.main.async {
        let points = [rect.topLeft, rect.topRight, rect.bottomRight, rect.bottomLeft]
        onRectDetected(points)
      }
    }

    self.requests = [rectReq]
  }

  /**
   * A method for stopping the calibration process.
   */
  internal func stopCalibration () {
    self.requests = []
  }

  internal func getBlankRectObservation () -> VNRectangleObservation {
    let obsrv = VNRectangleObservation(boundingBox: CGRect(x: -1, y: -1, width: 0, height: 0))
    return obsrv
  }

  /**
   * The method that's being called every time the camera produces an output buffer (through the delegate).
   * - parameter sampleBuffer: The CMSampleBuffer from the captureOutput delegate method
   * - parameter ciImage: The image produced from the custom UnChromaKey filter
   */
  func captureOutput (sample sampleBuffer: CMSampleBuffer, ci ciImage: CIImage) {
//    var reqOpts: [VNImageOption: Any] = [:]
//    if let camData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
//      reqOpts = [.cameraIntrinsics: camData]
//    }
//
//    let imageReqHandler = VNImageRequestHandler(ciImage: ciImage, orientation: .up, options: reqOpts)
//    try? imageReqHandler.perform(self.requests)
  }
}
