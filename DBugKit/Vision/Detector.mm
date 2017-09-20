//
//  Detector.m
//  3316 CV
//
//  Created by Jonathan Ohayon on 02/09/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

// Imports
#import <opencv2/opencv.hpp> // Main OpenCV lib
#import <opencv2/imgcodecs/ios.h> // iOS OpenCV utility functions
#import "../Utilities/Utilities.h" // CV utility functions
#import "Detector.h" // The declaration of the Detector class

@implementation Detector

- (NSArray<DBugRect *> *) getBoundingRectsInImage: (UIImage *) image {
  Mat mat;
  UIImageToMat(image, mat);
  PolygonArray contours;
  findContours(mat, contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE);
  filterContours(contours);
  return mapContours(contours);
}

@end
