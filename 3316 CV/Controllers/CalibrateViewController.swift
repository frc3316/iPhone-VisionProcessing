//
//  ViewController.swift
//  3316 CV
//
//  Created by Jonathan Ohayon on 12/08/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.

import AVFoundation
import UIKit

class CalibrateViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
  override var shouldAutorotate: Bool { return false }
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .landscapeRight }

  let detectionManager: DetectionManager = DetectionManager()
  let cameraManager: CameraManager = CameraManager(type: .video, settings: Constants.camera)
  let rectManager: RectangleManager = RectangleManager()

  // Color filter
  let colorFilter: ColorFilter = ColorFilter(
    lowerBoundColor: Constants.lowerColorBound,
    upperBoundColor: Constants.upperColorBound
  )

  @IBOutlet weak var preview: UIImageView!

  override func viewDidLoad () {
    super.viewDidLoad()

    self.cameraManager.run(on: self.view, with: self)

    let frame = self.view.frame
    self.rectManager.frame = frame
    self.view.layer.addSublayer(self.rectManager.render(in: frame))

    self.detectionManager.calibration.start { points in
      self.rectManager.emit(points: points, in: frame)
      let layer = self.rectManager.render(in: frame)
      self.view.layer.sublayers?.removeSubrange(1...)
      self.view.layer.addSublayer(layer)
    }
  }

  override func didReceiveMemoryWarning () {
    super.didReceiveMemoryWarning()
  }

  func captureOutput(_ output: AVCaptureOutput,
                     didOutput sampleBuffer: CMSampleBuffer,
                     from connection: AVCaptureConnection) {
    let masked = self.colorFilter.filterColors(of: sampleBuffer)
    DispatchQueue.main.async {
      self.preview.image = masked
    }
  }
}
