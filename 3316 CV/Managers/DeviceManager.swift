//
//  BatteryManager.swift
//  3316 CV
//
//  Created by Jonathan Ohayon on 03/10/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

import UIKit

class DeviceManager {
  weak var delegate: DeviceManagerDelegate?

  init () {
    UIDevice.current.isBatteryMonitoringEnabled = true

    let stateChanged: Notification.Name = .UIDeviceBatteryStateDidChange
    let levelChanged: Notification.Name = .UIDeviceBatteryLevelDidChange

    let batteryUpdate: (Any?) -> Void = { (_) -> Void in
      let level = Int(UIDevice.current.batteryLevel * 100)
      self.delegate?.batteryLevelChanged(with: level)
    }

    batteryUpdate(nil)

    NotificationCenter.default.addObserver(forName: stateChanged, object: nil, queue: nil, using: { (_) -> Void in
      let state = UIDevice.current.batteryState
      if state == .charging {
        self.delegate?.batteryLevelChanged(with: -1)
      } else if state == .unknown {
        Log.d("Battery state is unknown")
      }
    })

    NotificationCenter.default.addObserver(forName: levelChanged, object: nil, queue: nil, using: batteryUpdate)
  }
}

protocol DeviceManagerDelegate: class {
  func batteryLevelChanged (with level: Int)
}
