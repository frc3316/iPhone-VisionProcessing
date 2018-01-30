//
//  ViewController.swift
//  3316 CV
//
//  Created by Jonathan Ohayon on 12/08/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.

import AVFoundation
import UIKit

class RunViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, DeviceManagerDelegate {
  override var shouldAutorotate: Bool { return false }
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .landscapeRight }

  let cameraManager: CameraManager = CameraManager(type: .video, settings: Constants.camera)
  let rectManager: RectangleManager = RectangleManager()
  let sizeManager: SizeManager = SizeManager(measures: Constants.goalMeasures)
  let deviceManager: DeviceManager = DeviceManager()
  let networkManager: NetworkManager = NetworkManager(
    teamNumber: Constants.teamNumber,
    port: Constants.roborioPort
  )

  // Color filter
  let colorFilter: ColorFilter = ColorFilter(
    lowerBoundColor: Constants.lowerColorBound,
    upperBoundColor: Constants.upperColorBound
  )

  let detector: Detector = Detector()

  @IBOutlet weak var preview: UIImageView!
  @IBOutlet weak var polarLabel: UILabel!
  @IBOutlet weak var azimuthLabel: UILabel!
  @IBOutlet weak var batteryLabel: UILabel!
  @IBOutlet weak var flashSwitch: UISwitch!

  @IBAction func flashSwitchChanged (_ sender: UISwitch) {
    try? self.cameraManager.setFlash(sender.isOn)
  }

  @IBAction func back(_ sender: Any) {
    _ = navigationController?.popToRootViewController(animated: true)
  }

  override func viewDidLoad () {
    super.viewDidLoad()

    self.deviceManager.delegate = self
    self.flashSwitch.setOn(Constants.camera.flash, animated: true)
    self.cameraManager.run(on: self.view, with: self)
    self.networkManager.prepare()

    let frame = self.view.frame
    self.rectManager.frame = frame
    self.view.layer.addSublayer(self.rectManager.render(in: frame))
  }

  override func didReceiveMemoryWarning () {
    super.didReceiveMemoryWarning()
  }

  func batteryLevelChanged (with level: Int) {
    let txt = level < 0 ? "Charging" : "\(level)%"
    self.batteryLabel.text = "Battery: \(txt)"
  }

  func captureOutput(_ output: AVCaptureOutput,
                     didOutput sampleBuffer: CMSampleBuffer,
                     from connection: AVCaptureConnection) {
    // 1. Draw the masked colors image to the screen
    let masked = self.colorFilter.filterColors(of: sampleBuffer, isFlashOn: Constants.camera.flash)
    DispatchQueue.main.async {
      self.preview.image = masked
      self.preview.layer.sublayers?.removeAll()
    }

    // 2. Find the minimal bounding rectangles and get the biggest one's points array
    let boundingRects = self.detector.getBoundingRects(in: masked!) ?? []
    guard boundingRects.count > 0 else { Log.d("No rects found"); return }

    // 3. Send it to the roboRIO
//    let centroid = self.sizeManager.distanceFrom(rect: boundingRects[0])
//    self.networkManager.sendCentroid(with: centroid)

    // 4. Draw it to the screen
    DispatchQueue.main.async {
      let frame = self.preview.frame

      // Get the distance and the angle from the rectangle
      let centroid = self.sizeManager.distanceFrom(rect: boundingRects[0])
      self.polarLabel.text = "Polar: \(centroid.polar)"
      self.azimuthLabel.text = "Azimuth: \(centroid.azimuth)"

      // The first rectangle is the best match to our criteria
      self.rectManager.emit(rect: boundingRects[0])
      let layer = self.rectManager.render(in: frame)
      self.preview.layer.addSublayer(layer)
    }
  }
}
