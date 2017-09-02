//
//  RoundButton.swift
//  3316 CV
//
//  Created by Jonathan Ohayon on 13/08/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
  override func draw (_ rect: CGRect) {
    self.layer.cornerRadius = 10
    self.layer.masksToBounds = true
  }
}
