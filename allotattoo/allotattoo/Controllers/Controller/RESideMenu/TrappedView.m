//
//  TrappedView.m
//  allotattoo
//
//  Created by My Star on 8/23/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import "TrappedView.h"

@implementation TrappedView

- (void)drawRect:(CGRect)rect {
    CAShapeLayer *mask = [[CAShapeLayer alloc] init];
    mask.frame = self.layer.bounds;
    
    CGFloat width = self.layer.frame.size.width;
    CGFloat height = self.layer.frame.size.height;
    
    CGMutablePathRef path  = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, nil, width, 0);
    CGPathAddLineToPoint(path, nil, 0, 20);
    CGPathAddLineToPoint(path, nil, 0, height - 20);
    CGPathAddLineToPoint(path, nil, width, height);
    CGPathAddLineToPoint(path, nil, width, 0);
    CGPathCloseSubpath(path);
    
    mask.path = path;
    CGPathRelease(path);
    self.layer.mask = mask;
    
    CAShapeLayer *shape= [CAShapeLayer layer];
    shape.frame = self.bounds;
    shape.path = path;
    shape.lineWidth = 3.0f;
    shape.strokeColor = [UIColor whiteColor].CGColor;;
    shape.fillColor = [UIColor clearColor].CGColor;
    
    [self.layer insertSublayer:shape atIndex:0];
    
}


@end
