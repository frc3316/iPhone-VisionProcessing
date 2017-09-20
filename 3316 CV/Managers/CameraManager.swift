//
//  CameraManager.swift
//  3316 CV
//
//  Created by Jonathan Ohayon on 12/08/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

import AVFoundation
import Vision
import UIKit

class CameraManager {
  /// The capture session
  internal let session: AVCaptureSession

  /// The capture device to attach to the session
  internal let device: AVCaptureDevice

  /**
   * Initializes the CameraManager instance.
   * - parameter type: The wanted type of the device for the session
   * - parameter flashEnabled: Indicates whether the flash should be on by default. Default value - false.
   */
  init (type: AVMediaType, settings: CameraSettings) {
    self.session = AVCaptureSession()

    let device = AVCaptureDevice.default(for: type)!
    CameraManager.prepareCamera(camera: device, settings: settings)

    self.device = device
  }

  /**
   * Starts the camera session.
   * - parameter parent: The parent view to render the preview layer on
   * - parameter delegate: The delegate to attach to the session
   */
  func run (on parent: UIView, with delegate: AVCaptureVideoDataOutputSampleBufferDelegate?) {
    let hasInput = self.session.inputs.count > 0
    let hasOutput = self.session.outputs.count > 0
    if !hasInput || !hasOutput {
      self.prepareSession(delegate: delegate)
    }

    let child = AVCaptureVideoPreviewLayer(session: self.session)
    parent.layer.addSublayer(child)

    self.session.startRunning()
  }

  /**
   * Stops the running session.
   */
  func stop () {
    self.session.stopRunning()
  }

  /**
   * Prepares the session to have certain configurations.
   * - parameter delegate: The delegate to attach to the session
   */
  internal func prepareSession (delegate: AVCaptureVideoDataOutputSampleBufferDelegate?) {
    self.session.sessionPreset = .hd1280x720
    let input = try? AVCaptureDeviceInput(device: self.device)
    self.session.addInput(input!)

    // Preview output
    let preview = AVCaptureVideoDataOutput()
    preview.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
    preview.setSampleBufferDelegate(delegate, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
    self.session.addOutput(preview)
  }

  /**
   * Prepares the camera device using a given configuration.
   * - parameter camera: The AVCaptureDevice to configure
   * - parameter settings: The camera configuration object
   */
  internal static func prepareCamera (camera: AVCaptureDevice, settings: CameraSettings) {
    try? camera.lockForConfiguration()
    if settings.flash { try? camera.setTorchModeOn(level: 1.0) }
    camera.setExposureModeCustom(
      duration: CMTimeMake(1, settings.exposure.duration),
      iso: settings.exposure.iso,
      completionHandler: nil
    )
    camera.unlockForConfiguration()
  }
}
