//
//  CVUtils.mm
//  3316 CV
//
//  Created by Jonathan Ohayon on 10/09/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

#import "Utilities.h"
#import <math.h>

// The AVFoundation delegate for live camera feedback returns
// a CMSampleBuffer instead of an actual image. OpenCV was not able to use
// the image output of the buffer, so we're using the actual buffer data
// in this method (which also works a bit faster)
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

Mat thresholdFrame (Mat maskedFrame, double thresh, bool hasFlash) {
  Mat thresholded;
  threshold(maskedFrame, thresholded, thresh, 255, CV_THRESH_BINARY);
  erode(thresholded, thresholded, Mat());
  // If the flash is turned on, we should erode the image another time to get rid of the small reflections
  if (hasFlash) erode(thresholded, thresholded, Mat());
  return thresholded;
}

CGPoint pointFromCVPoint (cv::Point point) { return CGPointMake(point.x, point.y); }

Rectangle *rectFromCVRect (RotatedRect rotatedRect) {
  Point2f vtx[4]; rotatedRect.points(vtx);
  return [[Rectangle alloc] initWithTopLeft: pointFromCVPoint(vtx[1])
                                   topRight: pointFromCVPoint(vtx[0])
                                bottomRight: pointFromCVPoint(vtx[2])
                                 bottomLeft: pointFromCVPoint(vtx[3])];
}

Rectangle *rectFromCVRect (cv::Rect boundingRectangle) {
  CGPoint tld = pointFromCVPoint(boundingRectangle.tl());
  CGPoint trd = [PointUtils transformPointA: tld dx: boundingRectangle.width dy: 0];
  CGPoint brd = pointFromCVPoint(boundingRectangle.br());
  CGPoint bld = [PointUtils transformPointA: brd dx: -boundingRectangle.width dy: 0];
  return [[Rectangle alloc] initWithTopLeft: tld
                                   topRight: trd
                                bottomRight: brd
                                 bottomLeft: bld];
}

bool shouldFilterContour (int numOfPoints, double area, double ratio, Polygon convex) {
  bool isInAreaRange = area >= MIN_CONTOUR_AREA && area <= MAX_CONTOUR_AREA;
  bool isInRatioRange = ratio >= MIN_HEIGHT_WIDTH_RATIO && ratio <= MAX_HEIGHT_WIDTH_RATIO;
  return isContourConvex(convex)
    && isInAreaRange
    && isInRatioRange
    && numOfPoints >= 4;
}

// Filter contours by polygon vertex count, area range and ratio range
vector<RectInfoTuple> filterContours (PolygonArray contours) {
  vector<RectInfoTuple> filtered;
  for_each(contours.begin(), contours.end(), [&filtered] (Polygon contour) {
    Polygon convex;
    convexHull(contour, convex);
    RotatedRect rect = minAreaRect(convex);
    bool shouldFilter = shouldFilterContour((int) convex.size(), // Convex hull number of points
                                            contourArea(convex) / 100.0, // Convex hull area
                                            rect.boundingRect2f().height / rect.boundingRect2f().width, // Bounding rectangle height-width ratio
                                            convex); // The convex hull itself
    if (shouldFilter) {
      RectInfoTuple tuple {rect, rect.boundingRect()};
      filtered.push_back(tuple);
    }
  });
  return filtered;
}

Rectangle *minimalBoundingRectangle (RotatedRect rotatedRect, cv::Rect boundingRect) {
  double height = boundingRect.height - (tan(rotatedRect.angle) * boundingRect.width);
  double width = (rotatedRect.boundingRect2f().width / rotatedRect.boundingRect2f().height) * height;
  Point2f center = rotatedRect.center;
  Size2f size = Size2f(width, height);
  float angle = rotatedRect.angle;
  RotatedRect min = RotatedRect(center, size, angle);
  return rectFromCVRect(min);
}

NSMutableArray<Rectangle *> *mapContours (vector<RectInfoTuple> rects) {
  id transformed = [[NSMutableArray alloc] init];
  for_each(rects.begin(), rects.end(), [&transformed] (RectInfoTuple tuple) {
    RotatedRect rotatedRect = get<0>(tuple);
    cv::Rect boundingRect = get<1>(tuple);
    Rectangle *minimalBoundingRect = minimalBoundingRectangle(rotatedRect, boundingRect);
    [transformed addObject: minimalBoundingRect];
  });
  return transformed;
}
