//
//  NewRectUtils.h
//  3316 CV
//
//  Created by Jonathan Ohayon on 18/12/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface PointUtils : NSObject
+ (double) distanceBetweenA: (CGPoint) pointA
                          B: (CGPoint) pointB;

+ (CGPoint) transformPointA: (CGPoint) point
                         dx: (double) dx
                         dy: (double) dy;

+ (CGPoint) scalePointA: (CGPoint) point
                     dx: (double) dx
                     dy: (double) dy;

+ (CGPoint) centerBetweenA: (CGPoint) pointA
                         B: (CGPoint) pointB;
@end

@interface Rectangle : NSObject {
  CGPoint _points[4];
}

@property (readonly) CGPoint topLeft;
@property (readonly) CGPoint topRight;
@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;

- (id) initWithTopLeft: (CGPoint) topLeft
              topRight: (CGPoint) topRight
           bottomRight: (CGPoint) bottomRight
            bottomLeft: (CGPoint) bottomLeft;

- (CGPoint) getCentroid;
- (void) scaleWithFactor: (double) factor;
- (double) getWidth;
- (double) getHeight;

@end
