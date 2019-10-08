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

- (DBugPoint *) scaledWithX: (double) dx y: (double) dy {
  return [[DBugPoint alloc] initWithX: self.x * dx
                                    y: self.y * dy];
}

- (DBugPoint *) transformedWithX: (double) dx y: (double) dy {
  return [[DBugPoint alloc] initWithX: self.x + dx
                                    y: self.y + dy];
}

- (double) distanceFromPoint: (DBugPoint *) point {
  double dxs = exp2(self.x - point.x);
  double dys = exp2(self.y - point.y);
  return sqrt(dxs + dys);
}

- (DBugPoint *) centerWithPointB: (DBugPoint *) point {
  double avgX = (self.x + point.x) / 2;
  double avgY = (self.y + point.y) / 2;
  return [[DBugPoint alloc] initWithX: avgX
                                    y: avgY];
}

- (CGPoint) CGPoint {
  // yay c structs!
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
  DBugPoint *ct = [self.topLeft centerWithPointB: self.topRight];
  DBugPoint *cb = [self.bottomLeft centerWithPointB: self.bottomRight];
  return [ct centerWithPointB: cb];
}

- (DBugRect *) scalePointsWithFactor: (double) scaleFactor {
  DBugPoint *tl = [self.topLeft scaledWithX:scaleFactor y:scaleFactor];
  DBugPoint *tr = [self.topRight scaledWithX:scaleFactor y:scaleFactor];
  DBugPoint *br = [self.bottomRight scaledWithX:scaleFactor y:scaleFactor];
  DBugPoint *bl = [self.bottomLeft scaledWithX:scaleFactor y:scaleFactor];
  return [[DBugRect alloc] initWithTopLeft: tl
                                  topRight: tr
                               bottomRight: br
                                bottomLeft: bl];
}

- (double) getWidth {
  return [self.topLeft distanceFromPoint: self.topRight];
}

- (double) getHeight {
  return [self.topLeft distanceFromPoint: self.bottomLeft];
}

- (CGRect) CGRect {
  double width = [self getWidth];
  double height = [self getHeight];
  CGRect r = CGRectMake(self.topLeft.x, self.topLeft.y, width, height);
  return r;
}

@end

@implementation RectVector

- (id) initWithRect1: (DBugRect *) rect1 rect2: (DBugRect *) rect2 {
  if (self = [super init]) {
    self.rect1 = rect1;
    self.rect2 = rect2;
  }
  return self;
}

@end
