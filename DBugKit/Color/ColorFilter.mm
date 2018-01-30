//
//  ColorFilter.mm
//  3316 CV
//
//  Created by Jonathan Ohayon on 26/08/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

// Imports
#import <opencv2/opencv.hpp> // Main OpenCV lib
#import <opencv2/imgcodecs/ios.h> // iOS OpenCV utility functions
#import "ColorFilter.h" // The declaration of the ColorFilter class
#import "../Utilities/Utilities.h" // Utilities

using namespace cv;

@implementation ColorFilter

- (id) initWithLowerBoundColor: (DBugColor *) lowerBound
               upperBoundColor: (DBugColor *) upperBound {
  if (self = [super init]) {
    self.lowerBoundColor = lowerBound;
    self.upperBoundColor = upperBound;
  }
  return self;
}

- (UIImage *) filterColorsOfBuffer: (CMSampleBufferRef) buffer isFlashOn: (bool) isFlashOn {
  Mat input = sampleToMat(buffer);
  bool isBlack = self.lowerBoundColor.h == 0.0
              && self.lowerBoundColor.s == 0.0
              && self.lowerBoundColor.v == 0.0;
  bool isWhite = self.upperBoundColor.h == 255.0
              && self.upperBoundColor.s == 255.0
              && self.upperBoundColor.v == 255.0;
  if (isBlack && isWhite) return MatToUIImage(input);
  Scalar lb = colorToScalar(self.lowerBoundColor);
  Scalar ub = colorToScalar(self.upperBoundColor);
  Mat masked = maskFrame(input, lb, ub);
  Mat thresh = thresholdFrame(masked, 25, isFlashOn);
  return MatToUIImage(thresh);
}

@end
