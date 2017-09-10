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
#import "../Utilities/ColorUtils.h" // Color utilities
#import "../Utilities/CVUtils.h" // CV utilities

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

- (UIImage *) filterColorsOfBuffer: (CMSampleBufferRef) buffer {
  Mat input = sampleToMat(buffer);
  Mat masked = maskFrame(input, Scalar(65, 160, 170), Scalar(97, 255, 255));
  Mat thresh = thresholdFrame(masked, 25);
  return MatToUIImage(thresh);
}

@end
