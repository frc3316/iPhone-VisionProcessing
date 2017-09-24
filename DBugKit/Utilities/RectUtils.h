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

@property (nonatomic) double x;
@property (nonatomic) double y;

- (id) initWithX: (double) x
               y: (double) y;
- (void) transformDeltaX: (double) dx
                  deltaY: (double) dy;
- (DBugPoint *) scaledWithX: (double) dx
                          y: (double) dy;
- (double) getDistanceFromPoint: (DBugPoint *) point;
- (DBugPoint *) getCenterWithPointB: (DBugPoint *) point;

- (CGPoint) CGPoint;

@end

// Rectangle (polygon w/4 points) class
@interface DBugRect : NSObject

@property (nonatomic) DBugPoint *topLeft;
@property (nonatomic) DBugPoint *topRight;
@property (nonatomic) DBugPoint *bottomRight;
@property (nonatomic) DBugPoint *bottomLeft;

- (id) initWithTopLeft: (DBugPoint *) tl
              topRight: (DBugPoint *) tr
           bottomRight: (DBugPoint *) br
            bottomLeft: (DBugPoint *) bl;
- (NSArray<DBugPoint *> *) getPointsArray;
- (DBugPoint *) getCenteroid;
- (DBugRect *) scalePointsWithFactor: (double) scaleFactor;
- (CGRect) CGRect;

@end
