//
//  CVUtils.mm
//  3316 CV
//
//  Created by Jonathan Ohayon on 10/09/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

#import "VisionConstants.h"
#import "CVUtils.h"

// Since iOS 11, the AVFoundation delegate for live camera feedback returns
// a CMSampleBuffer instead of an actual image. OpenCV was not able to use
// the image output of the buffer, so we're using the actual buffer data
// in this method (which also works faster)
Mat sampleToMat (CMSampleBufferRef sample) {
  CVImageBufferRef buf = CMSampleBufferGetImageBuffer(sample);
  CVPixelBufferLockBaseAddress(buf, 0);

  size_t bytesPerRow = CVPixelBufferGetBytesPerRow(buf);
  size_t width = CVPixelBufferGetWidth(buf);
  size_t height = CVPixelBufferGetHeight(buf);
  unsigned char *address = (unsigned char*) CVPixelBufferGetBaseAddress(buf);

  Mat mat = Mat((int) height, (int) width, CV_8UC4, address, bytesPerRow);
  CVPixelBufferUnlockBaseAddress(buf, 0);
  return mat;
}

Mat maskFrame (Mat frame, Scalar lowerBound, Scalar upperBound) {
  Mat hsv, ranged;
  cvtColor(frame, hsv, CV_BGR2HSV);
  Scalar lb = lowerBound, ub = upperBound;
  inRange(hsv, lb, ub, ranged);
  return ranged;
}

Mat thresholdFrame (Mat maskedFrame, double thresh) {
  Mat thresholded;
  threshold(maskedFrame, thresholded, thresh, 255, CV_THRESH_BINARY);
  erode(thresholded, thresholded, Mat());
  return thresholded;
}

DBugPoint *dbugPointFromPoint (cv::Point point) { return [[DBugPoint alloc] initWithX: point.x y: point.y]; }

DBugRect *rectFromPoints (vector<cv::Point> points) {
  DBugPoint *tl = dbugPointFromPoint(points[0]);
  DBugPoint *tr = dbugPointFromPoint(points[1]);
  DBugPoint *br = dbugPointFromPoint(points[2]);
  DBugPoint *bl = dbugPointFromPoint(points[3]);
  return [[DBugRect alloc] initWithTopLeft: tl
                                  topRight: tr
                               bottomRight: br
                                bottomLeft: bl];
}

// Filter contours by polygon vertex count, area range and ratio range
PolygonArray filterContours (PolygonArray contours) {
//  PolygonArray filtered(contours.size());
//  copy_if(contours.begin(), contours.end(), filtered, [](vector<cv::Point> polygon) {
//    cv::Rect boundRect = boundingRect(polygon);
//    int area = boundRect.area(), ratio = boundRect.height / boundRect.width;
//    bool isInAreaRange = area > MIN_BOUND_RECT_AREA && area < MAX_BOUND_RECT_AREA;
//    bool isInRatioRange = ratio > MIN_HIGHT_WIDTH_RATIO && ratio < MAX_HIGHT_WIDTH_RATIO;
//    if (!isInAreaRange) NSLog(@"Rect with area %d denied because of area range.", area);
//    if (!isInRatioRange) NSLog(@"Rect with w/h ratio %d denied because of range.", ratio);
//    return polygon.size() == 4 && isInAreaRange && isInRatioRange;
//  });
  return contours;
}

NSMutableArray<DBugRect *> *mapContours (PolygonArray contours) {
  id transformed = [[NSMutableArray alloc] init];
  for_each(contours.begin(), contours.end(), [&transformed] (vector<cv::Point> contour) {
    DBugRect *rect = rectFromPoints(contour);
    [transformed addObject: rect];
  });
  return transformed;
}
