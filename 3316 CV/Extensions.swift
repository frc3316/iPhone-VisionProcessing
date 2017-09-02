//
//  Extensions.swift
//  3316 CV
//
//  Created by Jonathan Ohayon on 12/08/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

import CoreGraphics

extension CGPoint {
  func isIn (rect: CGRect) -> Bool {
    let xInBounds = self.x > rect.minX && self.x < rect.maxX
    let yInBounds = self.y > rect.minY && self.y < rect.maxY
    return xInBounds && yInBounds
  }
}
