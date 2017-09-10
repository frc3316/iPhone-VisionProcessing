//
//  CVUtils.h
//  3316 CV
//
//  Created by Jonathan Ohayon on 10/09/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <AVFoundation/AVFoundation.h>
#import <stdio.h>
#import "RectUtils.h"

using namespace cv;
using namespace std;

Mat sampleToMat (CMSampleBufferRef sample);
Mat maskFrame (Mat frame, Scalar lowerBound, Scalar upperBound);
Mat thresholdFrame (Mat maskedFrame, double thresh);
DBugRect *rectFromPoints (vector<cv::Point> points);
