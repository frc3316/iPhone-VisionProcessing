//
//  DBugColor.h
//  3316 CV
//
//  Created by Jonathan Ohayon on 02/09/2017.
//  Copyright © 2017 Jonathan Ohayon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBugColor : NSObject

@property (assign) double h;
@property (assign) double s;
@property (assign) double v;

- (id) initWithHue: (double) h
        saturation: (double) s
             value: (double) v;
- (UIColor *) UIColor;

@end
