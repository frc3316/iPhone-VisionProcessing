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

  let detector: Detector = Detector()

  @IBOutlet weak var preview: UIImageView!

  override func viewDidLoad () {
    super.viewDidLoad()

    self.cameraManager.run(on: self.view, with: self)

    let frame = self.view.frame
    self.rectManager.frame = frame
    self.view.layer.addSublayer(self.rectManager.render(in: frame))
  }

  override func didReceiveMemoryWarning () {
    super.didReceiveMemoryWarning()
  }

  func captureOutput(_ output: AVCaptureOutput,
                     didOutput sampleBuffer: CMSampleBuffer,
                     from connection: AVCaptureConnection) {
    // TODO - Beautify this snippet
    let masked = self.colorFilter.filterColors(of: sampleBuffer)
//    let boundingRects = self.detector.getBoundingRects(in: masked!) ?? []
//    guard boundingRects.count > 0 else { Log.d("no rects"); return }
//    let points = boundingRects[0].getPointsArray()
//    let frame = self.view.frame
//    self.rectManager.emit(points: points!, in: frame)
//    let layer = self.rectManager.render(in: frame)
//    self.view.layer.sublayers?.removeSubrange(1...)
//    self.view.layer.addSublayer(layer)
    DispatchQueue.main.async {
      self.preview.image = masked
    }
//    DispatchQueue.main.async {
//      self.preview.image = UIImage(
//        ciImage: CIImage(
//          cvPixelBuffer: CMSampleBufferGetImageBuffer(sampleBuffer)!
//        )
//      )
//    }
  }
}
