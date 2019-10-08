//
//  RectangleManager.swift
//  3316 CV
//
//  Created by Jonathan Ohayon on 18/08/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

import UIKit

class RectangleManager {
  // Internal instance members
  internal var rect: DBugRect?

  // Set the fill color for the shape layer
  var fillColor: UIColor = UIColor.clear

  // Set the stroke color for the shape layer
  var strokeColor: UIColor = UIColor.magenta

  // Set the line join style for the shape layer
  var lineJoin: String = kCALineJoinMiter

  // Set the line cap style for the shape layer
  var lineCap: String = kCALineCapRound

  // Set the frame of the shape layer
  var frame: CGRect?

  static let shared: RectangleManager = RectangleManager()

  /**
   * The RectangleManager constructor.
   * - parameter points: The initial points array of the rectangle.
   */
  init (rect: DBugRect? = nil) {
    self.rect = rect
  }

  // MARK: View helpers

  /**
   * Renders the rectangle onto the shape layer.
   * - returns: The shape layer with the rectangle on it
   */
  func render (in frame: CGRect) -> CALayer {
    let shape = self.getShapeLayer(for: frame)

    // If the points array == nil (aka first run), return the default shape
    guard let rect = self.rect else { return shape }

    // Get CGPoints of DBugPoints
    let topLeft = rect.topLeft.cgPoint()
    let topRight = rect.topRight.cgPoint()
    let bottomRight = rect.bottomRight.cgPoint()
    let bottomLeft = rect.bottomLeft.cgPoint()

    // If all good, continue to render the path on the layer
    let path = UIBezierPath()
    path.move(to: topLeft)
    path.addLine(to: topRight)
    path.addLine(to: bottomRight)
    path.addLine(to: bottomLeft)
    path.close()
    shape.path = path.cgPath

    // Render the center point of the polygon
    let center = rect.getCenteroid().cgPoint()
    let centerLayer = self.getPointLayer(for: center, colored: UIColor.red)
    shape.addSublayer(centerLayer)

    // Render the top left + bottom right in green
    let tlpl = self.getPointLayer(for: topLeft, colored: UIColor.green)
    let brpl = self.getPointLayer(for: bottomRight, colored: UIColor.green)
    shape.addSublayer(tlpl)
    shape.addSublayer(brpl)

    // Render the top right + bottom left in blue
    let trpl = self.getPointLayer(for: topRight, colored: UIColor.blue)
    let blpl = self.getPointLayer(for: bottomLeft, colored: UIColor.blue)
    shape.addSublayer(trpl)
    shape.addSublayer(blpl)

    return shape
  }

  /**
   * Changes the internal state's points array to be a new one.
   * - parameter points: The new points array
   */
  func emit (rect: DBugRect, in frame: CGRect) {
    self.rect = rect.scalePoints(withFactor: Constants.scaleFactor)
  }

  // MARK: Internal functions

  /**
   * Get a CALayer with a given color to mark a point on the screen
   */
  internal func getPointLayer (for point: CGPoint, colored: UIColor) -> CALayer {
    let layer = CALayer()
    let dist = CGFloat(Constants.pointLayerWidth / 2)
    let translation = CGAffineTransform(translationX: -dist, y: -dist)
    let size = CGSize(width: Constants.pointLayerWidth, height: Constants.pointLayerWidth)
    layer.frame = CGRect(origin: point.applying(translation), size: size)
    layer.backgroundColor = colored.cgColor
    return layer
  }

  /**
   * Get a CAShapeLayer in a given frame
   */
  internal func getShapeLayer (for frame: CGRect) -> CAShapeLayer {
    let shape = CAShapeLayer()
    shape.frame = frame
    shape.fillColor = self.fillColor.cgColor
    shape.strokeColor = self.strokeColor.cgColor
    shape.lineCap = self.lineCap
    shape.lineJoin = self.lineJoin
    return shape
  }
}
