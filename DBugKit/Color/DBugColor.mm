//
//  DBugColor.m
//  3316 CV
//
//  Created by Jonathan Ohayon on 02/09/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

#import "DBugColor.h"

@implementation DBugColor

- (id) initWithHue: (double) h
        saturation: (double) s
             value: (double) v {
  if (self = [super init]) {
    self.h = h;
    self.s = s;
    self.v = v;
  }
  return self;
}

- (id) initWithUIColor: (UIColor *) color {
  double h, s, v;
  [color getHue:&h saturation:&s brightness:&v alpha:nil];
  return [[DBugColor alloc] initWithHue: h * 255.0
                             saturation: s * 255.0
                                  value: v * 255.0];
}

- (UIColor *) UIColor {
  return [[UIColor alloc] initWithHue: self.h / 255.0
                           saturation: self.s / 255.0
                           brightness: self.v / 255.0
                                alpha: 1.0];
}

@end
