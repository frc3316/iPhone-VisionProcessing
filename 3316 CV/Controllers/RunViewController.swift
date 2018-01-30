//
//  ViewController.swift
//  3316 CV
//
//  Created by Jonathan Ohayon on 12/08/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.

import AVFoundation
import UIKit

class RunViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
  override var shouldAutorotate: Bool { return false }
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .landscapeRight }

  let cameraManager: CameraManager = CameraManager(type: .video, settings: Constants.camera)
  let rectManager: RectangleManager = RectangleManager()

  // Color filter
  let colorFilter: ColorFilter = ColorFilter(
    lowerBoundColor: Constants.lowerColorBound,
    upperBoundColor: Constants.upperColorBound
  )

  let detector: Detector = Detector()

  @IBOutlet weak var preview: UIImageView!
  @IBOutlet weak var dataLabel: UILabel!
  
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
    // 1. Draw the masked colors image to the screen
    let masked = self.colorFilter.filterColors(of: sampleBuffer, isFlashOn: Constants.camera.flash)
    let regularImage = self.colorFilter.image(from: sampleBuffer)
    DispatchQueue.main.async {
      self.preview.image = regularImage
      self.preview.layer.sublayers?.removeAll()
    }

    // 2. Find the minimal bounding rectangles and get the biggest one's points array
    let boundingRects = self.detector.getBoundingRects(in: masked!) ?? []
    guard boundingRects.count > 0 else { Log.d("No rects found"); return }

    // 3. Calculate the data using the rectangle
    let data = SizeManager.calculateData(from: boundingRects[0])

    // 4. Draw everything to the screen
    DispatchQueue.main.async {
      let frame = self.preview.frame

      // The first rectangle is the best match to our criteria
      self.rectManager.emit(rect: boundingRects[0], in: frame)
      let layer = self.rectManager.render(in: frame)
      self.preview.layer.addSublayer(layer)

      self.dataLabel.text = "Azimuth: \(data.0), Distance: \(data.1)"
    }
  }
}
