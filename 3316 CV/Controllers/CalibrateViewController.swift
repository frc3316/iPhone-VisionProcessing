//
//  CalibrateViewController.swift
//  3316 CV
//
//  Created by Jonathan Ohayon on 18/12/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

import UIKit

class CalibrateViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
  override var shouldAutorotate: Bool { return false }
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .landscapeRight }

  let cameraManager: CameraManager = CameraManager(type: .video, settings: Constants.camera)
  @IBOutlet weak var preview: UIImageView!
  @IBOutlet weak var flashSwitch: UISwitch!

  @IBAction func flashSwitched (_ sender: UISwitch) {
    try? self.cameraManager.setFlash(sender.isOn)
  }

  @IBAction func back(_ sender: Any) {
    _ = navigationController?.popToRootViewController(animated: true)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.flashSwitch.setOn(Constants.camera.flash, animated: true)
    self.cameraManager.run(on: self.view, with: self)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func captureOutput (_ output: AVCaptureOutput,
                      didDrop sampleBuffer: CMSampleBuffer,
                      from connection: AVCaptureConnection) {
    let lb = DBugColor(hue: 0, saturation: 0, value: 0)
    let ub = DBugColor(hue: 255, saturation: 255, value: 255)
    let colorFilter = ColorFilter(lowerBoundColor: lb, upperBoundColor: ub)
    let masked = colorFilter?.filterColors(of: sampleBuffer, isFlashOn: Constants.camera.flash)
    DispatchQueue.main.async {
      self.preview.image = masked
    }
  }
}
