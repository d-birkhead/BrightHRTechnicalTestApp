//
//  CustomTextField.m
//  BrightHRApp
//
//  Created by David Andrew Birkhead on 09/11/2017.
//  Copyright © 2017 David Birkhead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomTextField.h"

@interface CustomTextField()

@end

@implementation CustomTextField

-(id)init{
    if (self) {
        self = [super init];
    }
    
    return self;
}
- (void) drawPlaceholderInRect:(CGRect)rect
{
    [[UIColor whiteColor] setFill];
    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:16]];
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    border.borderColor = [UIColor whiteColor].CGColor;
    border.borderWidth = borderWidth;
    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height);
    // apply border to textfield
    [self.layer addSublayer:border];
    self.layer.masksToBounds = YES;
}
@end