

//
//  LSColorButton.m
//  LSScrollPage
//
//  Created by ls on 16/1/6.
//  Copyright © 2016年 song. All rights reserved.
//

#import "LSColorButton.h"
#import "LSLabel.h"
@interface LSColorButton ()
@property (nonatomic,weak) LSLabel *leftLabel;
@end
@implementation LSColorButton
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        LSLabel *leftLabel=[[LSLabel alloc]init];
        leftLabel.font=[UIFont systemFontOfSize:14];
        [self addSubview:leftLabel];
        self.leftLabel=leftLabel;
    }
    return self;
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    self.leftLabel.text=title;
    self.leftLabel.frame=self.bounds;
}
-(void)setType:(LSColorButtonType)type
{
    _type=type;
    if (type==LSColorButtonTypeLeft) {
        self.leftLabel.textColor=[UIColor blackColor];
    }else{
        self.leftLabel.textColor=[UIColor redColor];
    }
}
- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    [self bringSubviewToFront:self.leftLabel];
    
    if (scale<=0.00000) {
        self.leftLabel.frame=CGRectZero;
        return;
    }
    CGSize size = [self.currentTitle boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.titleLabel.font } context:nil].size;
    self.leftLabel.frame = CGRectMake(0, 0, size.width * scale + (self.frame.size.width - size.width) / 2, self.frame.size.height);
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
}
-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
//    self.leftLabel.backgroundColor=[UIColor lightGrayColor];
    self.leftLabel.backgroundColor=backgroundColor;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.leftLabel.defaultSize=self.bounds.size;
}
@end
