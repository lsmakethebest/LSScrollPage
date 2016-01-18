//
//  LSColorLabel.h
//  aaaaa
//
//  Created by ls on 16/1/4.
//  Copyright © 2016年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LSColorLabelTypeLeft,
    LSColorLabelTypeRight
} LSColorLabelType;
@interface LSColorLabel : UIView
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat  scale ;
@property (nonatomic, assign) CGSize defaultSize;
@property (nonatomic, assign) LSColorLabelType type;
@end
