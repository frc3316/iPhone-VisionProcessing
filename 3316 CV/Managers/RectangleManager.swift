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
  internal var points: [CGPoint]?

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

  /**
   * The RectangleManager constructor.
   * - parameter points: The initial points array of the rectangle.
   */
  init (points: [CGPoint]? = nil) {
    self.points = points
  }

  // MARK: View helpers

  /**
   * Renders the rectangle onto the shape layer.
   * - returns: The shape layer with the rectangle on it
   */
  func render (in frame: CGRect) -> CALayer {
    let shape = self.getShapeLayer(for: frame)

    // If the points array == nil (aka first run), return the default shape
    guard let points = self.points else { return shape }

    // Make sure we have actual points
    guard points.count > 0 else { return CAShapeLayer() }

    // If all good, continue to render the path on the layer
    let path = UIBezierPath()
    path.move(to: points[0])
    path.addLine(to: points[1])
    path.addLine(to: points[2])
    path.addLine(to: points[3])
    path.close()
    shape.path = path.cgPath

    // Render the center point of the polygon
    let center = self.getCenter(of: points)
    let cl = self.getPointLayer(for: center, colored: UIColor.red)
    shape.addSublayer(cl)

    // Render the top left + bottom right in green
    let tlpl = self.getPointLayer(for: points[0], colored: UIColor.green)
    let brpl = self.getPointLayer(for: points[2], colored: UIColor.green)
    shape.addSublayer(tlpl)
    shape.addSublayer(brpl)

    // Render the top right + bottom left in blue
    let trpl = self.getPointLayer(for: points[1], colored: UIColor.blue)
    let blpl = self.getPointLayer(for: points[3], colored: UIColor.blue)
    shape.addSublayer(trpl)
    shape.addSublayer(blpl)

    return shape
  }

  /**
   * Changes the internal state's points array to be a new one.
   * - parameter points: The new points array
   */
  func emit (points: [DBugPoint], in frame: CGRect) {
    self.points = points.map({ self.transformPoint($0.cgPoint(), in: frame) })
  }

  // MARK: Geometry functions

  internal func getCenter (of points: [CGPoint]?) -> CGPoint {
    guard let points = points else { return CGPoint.zero }

    let averageX = points.map({ $0.x }).reduce(1, +) / 4
    let averageY = points.map({ $0.y }).reduce(1, +) / 4

    return CGPoint(x: averageX - 2.5, y: averageY - 2.5)
  }

  // MARK: Internal functions

  internal func getPointLayer (for point: CGPoint, colored: UIColor) -> CALayer {
    let layer = CALayer()
    let translation = CGAffineTransform(translationX: -5, y: -5)
    layer.frame = CGRect(origin: point.applying(translation), size: CGSize(width: 10, height: 10))
    layer.backgroundColor = colored.cgColor
    return layer
  }

  internal func getShapeLayer (for frame: CGRect) -> CAShapeLayer {
    let shape = CAShapeLayer()
    shape.frame = frame
    shape.fillColor = self.fillColor.cgColor
    shape.strokeColor = self.strokeColor.cgColor
    shape.lineCap = self.lineCap
    shape.lineJoin = self.lineJoin
    return shape
  }

  /**
   * Transforms a given point's (x, y) values to actual visible ones.
   * - parameter point: The point to trasnform
   */
  internal func transformPoint (_ point: CGPoint, in rect: CGRect) -> CGPoint {
    let width = rect.width
    let height = rect.height
    let scale = CGAffineTransform(scaleX: width, y: height)
    let newPoint = CGPoint(x: point.x, y: 1 - point.y)
    return newPoint.applying(scale)
  }
}
