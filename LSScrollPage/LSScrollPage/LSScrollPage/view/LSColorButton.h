//
//  LSColorButton.h
//  LSScrollPage
//
//  Created by ls on 16/1/6.
//  Copyright © 2016年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    LSColorButtonTypeLeft,
    LSColorButtonTypeRight
} LSColorButtonType;
@interface LSColorButton : UIButton
@property (nonatomic, assign) LSColorButtonType type;
@property (nonatomic, assign) CGFloat scale;
@end
