//
//  Logger.swift
//  3316 CV
//
//  Created by Jonathan Ohayon on 14/09/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

import Foundation
import CFNetwork

// TODO - Add log sending through network to DS / SDB via the roboRIO
class Log {
  static var tag: String = "VISION"

  internal static func time () -> Double {
    let date = Date()
    return date.timeIntervalSince1970
  }

  static func i (_ message: String) {
    print("[\(Log.time())][\(Log.tag)][INFO] \(message)")
  }

  static func d (_ message: String) {
    print("[\(Log.time())][\(Log.tag)][DEBUG] \(message)")
  }

  static func w (_ message: String) {
    print("[\(Log.time())][\(Log.tag)][WARN] \(message)")
  }

  static func e (_ message: String) {
    print("[\(Log.time())][\(Log.tag)][ERROR] \(message)")
  }
}
