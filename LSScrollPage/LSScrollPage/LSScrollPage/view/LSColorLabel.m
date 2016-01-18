

//
//  LSColorLabel.m
//  aaaaa
//
//  Created by ls on 16/1/4.
//  Copyright © 2016年 song. All rights reserved.
//

#import "LSColorLabel.h"
#import "LSLabel.h"

@interface LSColorLabel ()

@property (nonatomic, weak) LSLabel* leftLabel;
@property (nonatomic, weak) UILabel* rightLabel;

@end
@implementation LSColorLabel
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        LSLabel* leftLabel = [[LSLabel alloc] init];
        leftLabel.showType = LSLabelTypeLeft;
        [self addSubview:leftLabel];
        self.leftLabel = leftLabel;
        leftLabel.backgroundColor = [UIColor lightGrayColor];

        UILabel* rightLabel = [[UILabel alloc] init];
        rightLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:rightLabel];
        self.rightLabel = rightLabel;
    }
    return self;
}

- (void)setFont:(UIFont*)font
{
    _font = font;
    self.leftLabel.font = font;
    self.rightLabel.font = font;
}
- (void)setDefaultSize:(CGSize)defaultSize
{
    _defaultSize = defaultSize;
    self.leftLabel.defaultSize = defaultSize;
}
- (void)setScale:(CGFloat)scale
{
    _scale = scale;

    CGSize size = [self.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.font } context:nil].size;
    self.leftLabel.frame = CGRectMake(0, 0, size.width * scale + (self.defaultSize.width - size.width) / 2, self.frame.size.height);
}
- (void)setText:(NSString*)text
{
    _text = text;
    self.leftLabel.text = text;
    self.rightLabel.text = text;
    self.leftLabel.frame = self.bounds;
    self.rightLabel.frame = self.bounds;
}
- (void)setType:(LSColorLabelType)type
{
    _type = type;
    if (type == LSColorLabelTypeLeft) {
        self.leftLabel.textColor = [UIColor blackColor];
        self.rightLabel.backgroundColor = [UIColor redColor];
    }
    else {
        self.leftLabel.textColor = [UIColor redColor];
        self.rightLabel.backgroundColor = [UIColor blackColor];
    }
}
@end
