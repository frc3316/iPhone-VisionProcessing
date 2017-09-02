//
//  ColorUtils.h
//  3316 CV
//
//  Created by Jonathan Ohayon on 31/08/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <AVFoundation/AVFoundation.h>
#import "../Color/DBugColor.h"

using namespace cv;

Scalar colorToScalar (UIColor *c);
Mat sampleToMat (CMSampleBufferRef sample);
Mat maskFrame (Mat frame, Scalar lowerBound, Scalar upperBound);
Mat thresholdFrame (Mat maskedFrame, double thresh);
