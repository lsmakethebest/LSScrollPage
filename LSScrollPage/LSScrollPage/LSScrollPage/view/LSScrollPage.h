//
//  LSScrollPage.h
//  LSScrollPage
//
//  Created by ls on 15/12/28.
//  Copyright © 2015年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LSContentController.h"
@class LSScrollPage;

@protocol LSScrollPageDelegate <NSObject>

/**
*  刷新数据回调方法
*
*  @param scrollPage       自己
*  @param index            当前为第几页
*  @param leftController   左侧控制器
*  @param midController    中间控制器
*  @param rightController  右侧控制器
*  @param needRefresh      NO只是设置数据 YES为代表刷新数据 因为此方法在滑动过程中会多次调用 只有在滑动结束时调用时needRefresh才为YES
*  @param scrollTop        点击了当前页国栋到顶部
*  @param contentOffsets_Y 存放每一页contentOffset.y的数组
*/
- (void)scrollPage:(LSScrollPage*)scrollPage setDataWithIndex:(NSInteger)index leftController:(LSContentController*)leftController midController:(LSContentController*)midController rightController:(LSContentController*)rightController needRefresh:(BOOL)needRefresh scrollTop:(BOOL)scrollTop contentOffsets_Y:(NSMutableDictionary*)contentOffsets_Y;

@end
@interface LSScrollPage : UIView
@property (nonatomic, strong) NSMutableArray* titles;
@property (nonatomic, strong) UIColor* titleColor;
@property (nonatomic, weak) id<LSScrollPageDelegate> delegate;
@property (nonatomic, strong) UIFont *titleFont;

@end
