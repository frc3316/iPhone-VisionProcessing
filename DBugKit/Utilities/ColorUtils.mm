//
//  ColorUtils.mm
//  3316 CV
//
//  Created by Jonathan Ohayon on 31/08/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

#include "ColorUtils.h"

Scalar colorToScalar (DBugColor *c) {
//  double mod = HSV_MODIFIER * 255.0;
//  double v = c.v - mod < 0 ? 0 : c.v - mod;
  return Scalar(c.h, c.s, c.v, 255.0);
}
