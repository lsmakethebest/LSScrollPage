//
//  LSContentController.h
//  LSScrollPage
//
//  Created by ls on 15/12/28.
//  Copyright © 2015年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"
#import "NewsModel.h"
@interface LSContentController : UITableViewController


/*
 每一界面模型
 */
@property (nonatomic, strong) NewsModel *newsModel;
/*
 当刷新当前tableView时禁止scrollView滑动但是允许点击切换
 */
@property (nonatomic, copy) void(^actionBlock)(BOOL success);
/*
 只是单纯显示旧数据，没有则什么也不显示
 */
-(void)setData:(NewsModel*)newsModel needRefresh:(BOOL)needRefresh scrollTop:(BOOL)scrollTop contentOffset_Y:(CGFloat)contentOffset_Y;
/*
 当点击标签切换界面时来停止上一页面所有网络操作
 */
-(void)cancelNetworkingOperation;

@end
