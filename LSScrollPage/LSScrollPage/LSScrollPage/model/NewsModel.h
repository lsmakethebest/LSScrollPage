//
//  NewsModel.h
//  LSScrollPage
//
//  Created by ls on 16/1/2.
//  Copyright © 2016年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
/*
 每一页面的名称
 */
@property (nonatomic, copy) NSString *name;
/*
 存放每一页面新闻的数组
 */
@property (nonatomic, strong) NSMutableArray *newsArray;
@end
