//
//  LSLabel.h
//  aaaaa
//
//  Created by ls on 16/1/4.
//  Copyright © 2016年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSColorLabel.h"
typedef enum {

    LSLabelTypeLeft,
    LSLabelTypRight
}
LSLabelType;

@interface LSLabel : UILabel
@property (nonatomic, assign) LSLabelType showType;
@property (nonatomic, assign) CGSize defaultSize;
@end
