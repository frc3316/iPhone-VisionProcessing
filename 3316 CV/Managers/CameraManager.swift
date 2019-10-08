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

  /// A shared mananger instance (singleton)
  static let sharedVideo: CameraManager = CameraManager(type: .video, settings: Constants.camera)

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
   * Sets the flash state of the camera.
   * - parameter newState: A boolean stating the new state of the flash.
   */
  func setFlash (_ newState: Bool) throws {
    try self.device.lockForConfiguration()
    if newState {
      try self.device.setTorchModeOn(level: 1.0)
    } else {
      self.device.torchMode = .off
    }
    self.device.unlockForConfiguration()
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
      duration: CMTimeMake(1, settings.exposure),
      iso: camera.activeFormat.minISO,
      completionHandler: nil
    )
    camera.unlockForConfiguration()
  }
}
