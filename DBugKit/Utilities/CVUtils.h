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

// Custom types
using Polygon = vector<cv::Point>;
using PolygonArray = vector<Polygon>;

// Matrix manipulations
Mat sampleToMat (CMSampleBufferRef sample);
void maskFrame (Mat *frame, Scalar lowerBound, Scalar upperBound);
void thresholdFrame (Mat *input, double thresh, bool hasFlash);

// Type handling
DBugPoint *dbugPointFromPoint (Point2f point);
DBugRect *rectFromPoints (Point2f tl, Point2f tr, Point2f br, Point2f bl);

// Contours
vector<RotatedRect> filterContours (PolygonArray contours);
NSMutableArray<DBugRect *> *mapContours (vector<RotatedRect> rects);
