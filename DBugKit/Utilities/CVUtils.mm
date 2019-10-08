//
//  CVUtils.mm
//  3316 CV
//
//  Created by Jonathan Ohayon on 10/09/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

#import "Constants.h"
#import "Utilities.h"

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

  NSLog(@"Width: %zu, Height: %zu", width, height);
  Mat mat((int) height, (int) width, CV_8UC4, address, bytesPerRow);
  CVPixelBufferUnlockBaseAddress(buf, 0);

  return mat;
}

void maskFrame (Mat *frame, Scalar lowerBound, Scalar upperBound) {
  cvtColor(*frame, *frame, CV_BGR2HSV);
  inRange(*frame, lowerBound, upperBound, *frame);
}

void thresholdFrame (Mat *frame, double thresh, bool hasFlash) {
  threshold(*frame, *frame, thresh, 255, CV_THRESH_BINARY);
  erode(*frame, *frame, Mat());
  // If the flash is turned on, we should erode the image another time to get rid of the small reflections
  if (hasFlash) erode(*frame, *frame, Mat());
}

DBugPoint *dbugPointFromPoint (Point2f point) { return [[DBugPoint alloc] initWithX: point.x y: point.y]; }

DBugRect *rectFromPoints (Point2f tl, Point2f tr, Point2f br, Point2f bl) {
  DBugPoint *tld = dbugPointFromPoint(tl);
  DBugPoint *trd = dbugPointFromPoint(tr);
  DBugPoint *brd = dbugPointFromPoint(br);
  DBugPoint *bld = dbugPointFromPoint(bl);
  return [[DBugRect alloc] initWithTopLeft: tld
                                  topRight: trd
                               bottomRight: brd
                                bottomLeft: bld];
}

DBugRect *dbugRectFromRotated (RotatedRect rect) {
  Point2f vtx[4]; rect.points(vtx);
  DBugRect *dbugRect = rectFromPoints(vtx[0], vtx[1], vtx[2], vtx[3]);
  dbugRect.width = rect.boundingRect2f().width;
  dbugRect.height = rect.boundingRect2f().height;
  dbugRect.angle = rect.angle;
  return dbugRect;
}

bool shouldFilterContour (int numOfPoints, double area, double ratio, Polygon convex) {
  bool isInAreaRange = area >= MIN_CONTOUR_AREA;// && area <= MAX_CONTOUR_AREA;
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
    if (shouldFilter) filtered.push_back(make_tuple(rect, rect.boundingRect()));
  });
  return filtered;
}

NSMutableArray<DBugRect *> *mapContours (vector<RectInfoTuple> rects) {
  id transformed = [[NSMutableArray alloc] init];
  for_each(rects.begin(), rects.end(), [&transformed] (RectInfoTuple rect) {
    DBugRect *rectd = dbugRectFromRotated(get<0>(rect));
    [transformed addObject:rectd];
  });
  return transformed;
}
