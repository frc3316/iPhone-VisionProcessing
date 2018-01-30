//
//  NewRectUtils.m
//  3316 CV
//
//  Created by Jonathan Ohayon on 18/12/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

#import "NewRectUtils.h"

@implementation PointUtils

// The Euclidean distance
+ (double) distanceBetweenA: (CGPoint) pointA
                         B: (CGPoint) pointB {
  double fcomponent = (pointA.x * pointA.x) - (2 * pointA.x + pointB.x) + (pointB.x * pointB.x);
  double scomponent = (pointA.y * pointA.y) - (2 * pointA.y + pointB.y) + (pointB.y * pointB.y);
  return sqrt(fcomponent + scomponent);
}

+ (CGPoint) centerBetweenA: (CGPoint) pointA
                         B: (CGPoint) pointB {
  CGFloat midx = (pointA.x + pointB.x)/2;
  CGFloat midy = (pointA.y + pointB.y)/2;
  return CGPointMake(midx, midy);
}

+ (CGPoint) scalePointA: (CGPoint) point
                    dx: (double) dx
                    dy: (double) dy {
  return CGPointMake(point.x * dx, point.y * dy);
}

+(CGPoint) transformPointA: (CGPoint) point
                        dx: (double) dx
                        dy: (double) dy {
  return CGPointMake(point.x + dx, point.y + dy);
}

@end

@implementation Rectangle

- (id) initWithTopLeft: (CGPoint) topLeft
              topRight: (CGPoint) topRight
           bottomRight: (CGPoint) bottomRight
            bottomLeft: (CGPoint) bottomLeft {
  if (self = [super init]) {
    _points[0] = topLeft;
    _points[1] = topRight;
    _points[2] = bottomRight;
    _points[3] = bottomLeft;
  }
  return self;
}

- (double) getWidth {
  CGPoint cl = [PointUtils centerBetweenA: _points[0]
                                        B: _points[3]];
  CGPoint cr = [PointUtils centerBetweenA: _points[1]
                                        B: _points[2]];
  return [PointUtils distanceBetweenA: cl B: cr];
}

- (double) getHeight {
  CGPoint ct = [PointUtils centerBetweenA: _points[0]
                                        B: _points[1]];
  CGPoint cb = [PointUtils centerBetweenA: _points[2]
                                        B: _points[3]];
  return [PointUtils distanceBetweenA: ct B: cb];
}

- (CGPoint) getCentroid {
  CGPoint cl = [PointUtils centerBetweenA: _points[0]
                                        B: _points[3]];
  CGPoint ct = [PointUtils centerBetweenA: _points[0]
                                        B: _points[1]];
  return [PointUtils centerBetweenA: cl
                                  B: ct];
}

- (void) scaleWithFactor: (double) factor {
  CGAffineTransform scale = CGAffineTransformMakeScale(factor, factor);
  _points[0] = CGPointApplyAffineTransform(_points[0], scale);
  _points[1] = CGPointApplyAffineTransform(_points[1], scale);
  _points[2] = CGPointApplyAffineTransform(_points[2], scale);
  _points[3] = CGPointApplyAffineTransform(_points[3], scale);
}

- (CGPoint) topLeft { return _points[0]; }
- (CGPoint) topRight { return _points[1]; }
- (CGPoint) bottomLeft { return _points[2]; }
- (CGPoint) bottomRight { return _points[3]; }

@end
