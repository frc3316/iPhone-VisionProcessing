//
//  RectUtils.m
//  3316 CV
//
//  Created by Jonathan Ohayon on 10/09/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

#import "RectUtils.h"

// Point
@implementation DBugPoint

- (id) initWithX: (double) x
               y: (double) y {
  if (self = [super init]) {
    self.x = x;
    self.y = y;
  }
  return self;
}

- (void) transformDeltaX: (double) dx
                  deltaY: (double) dy {
  self.x += dx;
  self.y += dy;
}

- (double) getDistanceFromPoint: (DBugPoint *) point {
  double dxs = exp2(self.x - point.x);
  double dys = exp2(self.y - point.y);
  return sqrt(dxs + dys);
}

- (DBugPoint *) getCenterWithPointB: (DBugPoint *) point {
  double avgX = (self.x + point.x) / 2;
  double avgY = (self.y + point.y) / 2;
  return [[DBugPoint alloc] initWithX: avgX
                                    y: avgY];
}

- (CGPoint) CGPoint {
  // yuck c structs
  CGPoint p;
  p.x = self.x;
  p.y = self.y;
  return p;
}

@end

// Rectangle
@implementation DBugRect

- (id) initWithTopLeft: (DBugPoint *) tl
              topRight: (DBugPoint *) tr
           bottomRight: (DBugPoint *) br
            bottomLeft: (DBugPoint *) bl {
  if (self = [super init]) {
    self.topLeft = tl;
    self.topRight = tr;
    self.bottomRight = br;
    self.bottomLeft = bl;
  }
  return self;
}

- (NSArray<DBugPoint *> *) getPointsArray {
  NSArray<DBugPoint *> *set = [[NSArray alloc] initWithObjects: self.topLeft, self.topRight, self.bottomRight, self.bottomLeft, nil];
  return set;
}

- (DBugPoint *) getCenteroid {
  DBugPoint *ct = [self.topLeft getCenterWithPointB: self.topRight];
  DBugPoint *cb = [self.bottomLeft getCenterWithPointB: self.bottomRight];
  return [ct getCenterWithPointB: cb];
}

- (CGRect) CGRect {
  double width = [self.topLeft getDistanceFromPoint: self.topRight];
  double height = [self.topLeft getDistanceFromPoint: self.bottomLeft];
  CGRect r = CGRectMake(self.topLeft.x, self.topLeft.y, width, height);
  return r;
}

@end
