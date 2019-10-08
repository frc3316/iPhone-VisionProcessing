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

  @IBOutlet weak var minHSlider: UISlider!
  @IBOutlet weak var minSSlider: UISlider!
  @IBOutlet weak var minVSlider: UISlider!

  @IBOutlet weak var maxHSlider: UISlider!
  @IBOutlet weak var maxSSlider: UISlider!
  @IBOutlet weak var maxVSlider: UISlider!

  @IBAction func onSliderChange(_ slider: UISlider) {
    print("\(slider.restorationIdentifier) value: \(slider.value)")
    self.updateConfig()
  }

  @IBAction func onMaskChange(_ sender: UISwitch) {
    self.shouldDisplayMaskedOutput = sender.isOn
  }

  func updateConfig() {
    Constants.lowerColorBound?.h = Double(minHSlider.value)
    Constants.lowerColorBound?.s = Double(minSSlider.value)
    Constants.lowerColorBound?.v = Double(minVSlider.value)
    Constants.upperColorBound?.h = Double(maxHSlider.value)
    Constants.upperColorBound?.s = Double(maxSSlider.value)
    Constants.upperColorBound?.v = Double(maxVSlider.value)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    CameraManager.sharedVideo.run(on: self.view, with: self)

    minHSlider.value = Float(Constants.lowerColorBound?.h ?? 0)
    minSSlider.value = Float(Constants.lowerColorBound?.s ?? 0)
    minVSlider.value = Float(Constants.lowerColorBound?.v ?? 0)
    maxHSlider.value = Float(Constants.upperColorBound?.h ?? 0)
    maxSSlider.value = Float(Constants.upperColorBound?.s ?? 0)
    maxVSlider.value = Float(Constants.upperColorBound?.v ?? 0)
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
