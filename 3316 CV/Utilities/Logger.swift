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

  internal static func time () -> Int {
    let date = Date()
    return Int(date.timeIntervalSince1970 * 100 * 1000)
  }

  static func i (_ message: Any) {
    print("[\(Log.time())][\(Log.tag)][INFO] \(message)")
  }

  static func d (_ message: Any) {
    print("[\(Log.time())][\(Log.tag)][DEBUG] \(message)")
  }

  static func w (_ message: Any) {
    print("[\(Log.time())][\(Log.tag)][WARN] \(message)")
  }

  static func e (_ message: Any) {
    print("[\(Log.time())][\(Log.tag)][ERROR] \(message)")
  }
}
