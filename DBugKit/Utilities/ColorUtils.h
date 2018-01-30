//
//  ColorUtils.h
//  3316 CV
//
//  Created by Jonathan Ohayon on 31/08/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

#import "Constants.h"
#import <opencv2/opencv.hpp>
#import "../Color/DBugColor.h"

using namespace cv;

Scalar colorToScalar (DBugColor *c);
