//
//  NetworkManager.swift
//  3316 CV
//
//  Created by Jonathan Ohayon on 06/10/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

struct JSONCentroid: Encodable {
  var distance: Double
  var polarAngle: Double
  var azimuthAngle: Double
  var isObjectDetected: Bool

  init (from centroid: Centroid) {
    self.distance = centroid.distance
    self.polarAngle = centroid.polar
    self.azimuthAngle = centroid.azimuth
    self.isObjectDetected = centroid.isDetected
  }

  enum CentroidKeys: String, CodingKey {
    case distance = "DA"
    case polarAngle = "PA"
    case azimuthAngle = "AA"
    case isObjectDetected = "IOD"
  }
}

@objc class NetworkManager: NSObject, GCDAsyncUdpSocketDelegate {
  let teamNumber: Int
  let port: UInt16
  internal let host: String
  internal var socket: GCDAsyncUdpSocket?
  internal static let encoder = JSONEncoder()

  init (teamNumber: Int, port: UInt16) {
    self.teamNumber = teamNumber
    self.port = port
    self.host = "roborio-\(self.teamNumber)-frc.local"
  }

  func prepare () {
    if self.socket == nil {
      let socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
      try? socket.bind(toPort: 0)
      try? socket.beginReceiving()
      self.socket = socket
    }
  }

  func sendCentroid (with centroid: Centroid) {
    let json = JSONCentroid(from: centroid)
    let data = try? NetworkManager.encoder.encode(json)
//    self.socket?.send(data!, toHost: self.host, port: self.port, withTimeout: -1, tag: 3316)
    let str = String(data: data!, encoding: .utf16)
    Log.d("data: \(str!)")
  }
}
