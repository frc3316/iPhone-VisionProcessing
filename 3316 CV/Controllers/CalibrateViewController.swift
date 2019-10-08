//
//  CalibrateViewController.swift
//  3316 CV
//
//  Created by Jonathan Ohayon on 08/10/2019.
//  Copyright © 2019 Jonathan Ohayon. All rights reserved.
//

import UIKit

class CalibrateViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
  override var shouldAutorotate: Bool { return false }
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .landscapeRight }

  let colorFilter: ColorFilter = ColorFilter(
    lowerBoundColor: Constants.lowerColorBound,
    upperBoundColor: Constants.upperColorBound
  )

  var shouldDisplayMaskedOutput: Bool = false

  @IBOutlet weak var preview: UIImageView!

  @IBAction func onSliderChange(_ slider: UISlider) {
    guard let sliderId = slider.restorationIdentifier else { return }
    print("Slider value: \(slider.value); Restoration ID: \(sliderId)")
    switch sliderId {
    case "minh": Constants.lowerColorBound?.h = Double(slider.value)
    case "mins": Constants.lowerColorBound?.s = Double(slider.value)
    case "minv": Constants.lowerColorBound?.v = Double(slider.value)
    case "maxh": Constants.upperColorBound?.h = Double(slider.value)
    case "maxs": Constants.upperColorBound?.s = Double(slider.value)
    case "maxv": Constants.upperColorBound?.v = Double(slider.value)
    default:
      return
    }
  }

  @IBAction func onMaskChange(_ sender: UISwitch) {
    self.shouldDisplayMaskedOutput = sender.isOn
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    CameraManager.sharedVideo.run(on: self.view, with: self)
  }

  func captureOutput(_ output: AVCaptureOutput,
                     didOutput sampleBuffer: CMSampleBuffer,
                     from connection: AVCaptureConnection) {
    let masked = self.colorFilter.filterColors(of: sampleBuffer, isFlashOn: Constants.camera.flash)
    let regular = self.colorFilter.image(from: sampleBuffer)
    DispatchQueue.main.async {
      self.preview.image = self.shouldDisplayMaskedOutput ? masked : regular
      self.preview.layer.sublayers?.removeAll()
    }
  }
}
