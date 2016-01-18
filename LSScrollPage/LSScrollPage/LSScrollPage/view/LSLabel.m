

//
//  LSLabel.m
//  aaaaa
//
//  Created by ls on 16/1/4.
//  Copyright © 2016年 song. All rights reserved.
//

#import "LSLabel.h"

@implementation LSLabel

- (void)setFont:(UIFont*)font
{
    [super setFont:font];
}
- (void)drawTextInRect:(CGRect)rect
{
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.font } context:nil].size;
    [self.text drawInRect:CGRectMake((self.defaultSize.width - size.width) / 2, (self.defaultSize.height - size.height) / 2, size.width, size.height) withAttributes:@{ NSForegroundColorAttributeName : self.textColor, NSFontAttributeName : self.font }];
}

@end
