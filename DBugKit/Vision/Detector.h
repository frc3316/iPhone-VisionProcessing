//
//  Detector.h
//  3316 CV
//
//  Created by Jonathan Ohayon on 02/09/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

// Frameworks
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

#import "../Color/ColorFilter.h" // ColorFilter def
#import "../Utilities/NewRectUtils.h" // Rectangle utilities

@interface Detector : NSObject

- (NSArray<Rectangle *> *) getBoundingRectsInImage: (UIImage *) image;

@end
