//
//  RectUtils.h
//  3316 CV
//
//  Created by Jonathan Ohayon on 10/09/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

// Point class
@interface DBugPoint : NSObject

@property (assign) double x;
@property (assign) double y;

- (id) initWithX: (double) x
               y: (double) y;
- (void) transformDeltaX: (double) dx
                  deltaY: (double) dy;
- (DBugPoint *) scaledWithX: (double) dx
                          y: (double) dy;
- (DBugPoint *) transformedWithX: (double) dx
                               y: (double) dy;
- (double) distanceFromPoint: (DBugPoint *) point;
- (DBugPoint *) centerWithPointB: (DBugPoint *) point;

- (CGPoint) CGPoint;

@end

// Rectangle (polygon w/4 points) class
@interface DBugRect : NSObject

@property (assign) DBugPoint *topLeft;
@property (assign) DBugPoint *topRight;
@property (assign) DBugPoint *bottomRight;
@property (assign) DBugPoint *bottomLeft;

- (id) initWithTopLeft: (DBugPoint *) tl
              topRight: (DBugPoint *) tr
           bottomRight: (DBugPoint *) br
            bottomLeft: (DBugPoint *) bl;
- (NSArray<DBugPoint *> *) getPointsArray;
- (DBugPoint *) getCenteroid;
- (DBugRect *) scalePointsWithFactor: (double) scaleFactor;
- (double) getWidth;
- (double) getHeight;
- (CGRect) CGRect;

@end

@interface RectVector : NSObject

@property (assign) DBugRect *rect1;
@property (assign) DBugRect *rect2;

- (id) initWithRect1: (DBugRect *) rect1 rect2: (DBugRect *) rect2;

@end
