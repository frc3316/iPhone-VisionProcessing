//
//  Detector.h
//  3316 CV
//
//  Created by Jonathan Ohayon on 02/09/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "../Utilities/RectUtils.h" // Rectangle utilities

@interface Detector : NSObject

- (NSSet<DBugRect *> *) getBoundingRects;

@end
