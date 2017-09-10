//
//  CVUtils.mm
//  3316 CV
//
//  Created by Jonathan Ohayon on 10/09/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

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
  dilate(thresholded, thresholded, Mat());
  return thresholded;
}
