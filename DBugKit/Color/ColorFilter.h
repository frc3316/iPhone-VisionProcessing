//
//  ColorFilter.h
//  3316 CV
//
//  Created by Jonathan Ohayon on 26/08/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "DBugColor.h"

@interface ColorFilter : NSObject

@property (assign) DBugColor *upperBoundColor;
@property (assign) DBugColor *lowerBoundColor;

// Instance methods
- (id) initWithLowerBoundColor: (DBugColor *) lowerBound
               upperBoundColor: (DBugColor *) upperBound;
- (UIImage *) filterColorsOfBuffer: (CMSampleBufferRef) buffer isFlashOn: (bool) isFlashOn;

@end
