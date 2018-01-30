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
#import "NewRectUtils.h"

using namespace cv;
using namespace std;

// Custom types
using Polygon = vector<cv::Point>;
using PolygonArray = vector<Polygon>;
using RectInfoTuple = tuple<RotatedRect, cv::Rect>;

// Matrix manipulations
Mat sampleToMat (CMSampleBufferRef sample);
Mat maskFrame (Mat frame, Scalar lowerBound, Scalar upperBound);
Mat thresholdFrame (Mat maskedFrame, double thresh, bool hasFlash);

// Type handling
Rectangle *rectFromCVRect (RotatedRect rotatedRect);
Rectangle *rectFromCVRect (cv::Rect boundingRectangle);

// Contours
vector<RectInfoTuple> filterContours (PolygonArray contours);
NSMutableArray<Rectangle *> *mapContours (vector<RectInfoTuple> rects);
