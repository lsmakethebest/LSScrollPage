//
//  ViewController.m
//  LSScrollPage
//
//  Created by ls on 15/12/28.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSScrollPage.h"
#import "ViewController.h"
#import "NewsModel.h"
@interface ViewController () <LSScrollPageDelegate>

@property (nonatomic, strong) NSMutableArray* newsArray;
@end

@implementation ViewController

- (NSMutableArray*)newsArray
{
    if (_newsArray == nil) {
        _newsArray = [NSMutableArray array];
    }
    return _newsArray;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    LSScrollPage* page = [[LSScrollPage alloc] init];
    CGSize size=[UIScreen mainScreen].bounds.size;
    page.frame = CGRectMake(0, 20, size.width, size.height-20);
    //此处是模拟联网请求数据，正常是联网获取
    for (int i = 0; i < 7; i++) {
        NewsModel *model=[[NewsModel alloc]init];
        model.name=[NSString stringWithFormat:@"页面%d",i];
        NSMutableArray *news=[NSMutableArray array];
        for (int j=0; j<5; j++) {
            [news addObject:[NSString stringWithFormat:@"页面%d哈哈%d",i,j]];
        }
        model.newsArray=news;
        [self.newsArray addObject:model];
    }
    page.delegate = self;
    
    
    NSMutableArray *titles=[NSMutableArray array];
    for (NewsModel *model in self.newsArray) {
        [titles addObject:model.name];
    }
    page.titles = titles;
    [self.view addSubview:page];
}
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
- (void)scrollPage:(LSScrollPage*)scrollPage setDataWithIndex:(NSInteger)index leftController:(LSContentController*)leftController midController:(LSContentController*)midController rightController:(LSContentController*)rightController needRefresh:(BOOL)needRefresh scrollTop:(BOOL)scrollTop contentOffsets_Y:(NSMutableDictionary*)contentOffsets_Y
{
    if (index == 0) {
        if (scrollTop) { //点击的按钮是当前页滚动到顶部 证明曾经设置过两侧的数据所以不用再次设置其他页面的数据
            [leftController setData:self.newsArray[index ] needRefresh:needRefresh scrollTop:scrollTop contentOffset_Y:0];
            return;
        }
        [leftController setData:self.newsArray[index] needRefresh:needRefresh scrollTop:scrollTop contentOffset_Y:[contentOffsets_Y[@(index)] doubleValue]];
        [midController setData:self.newsArray[index + 1] needRefresh:NO scrollTop:scrollTop contentOffset_Y:[contentOffsets_Y[@(index+1)] doubleValue]];
        [rightController setData:self.newsArray[index + 2 ] needRefresh:NO scrollTop:scrollTop contentOffset_Y:[contentOffsets_Y[@(index+2)] doubleValue]];
    }
    else if (index == self.newsArray.count - 1) {
        if (scrollTop) { //点击的按钮是当前页滚动到顶部 证明曾经设置过两侧的数据所以不用再次设置
            [rightController setData:self.newsArray[index ] needRefresh:needRefresh scrollTop:scrollTop contentOffset_Y:0];
            return;
        }
        [leftController setData:self.newsArray[index - 2 ] needRefresh:NO scrollTop:scrollTop contentOffset_Y:[contentOffsets_Y[@(index-2)] doubleValue]];
        [midController setData:self.newsArray[index - 1 ] needRefresh:NO scrollTop:scrollTop contentOffset_Y:[contentOffsets_Y[@(index-1)] doubleValue]];
        [rightController setData:self.newsArray[index ] needRefresh:needRefresh scrollTop:scrollTop contentOffset_Y:[contentOffsets_Y[@(index)] doubleValue]];
    }
    else {
        if (scrollTop) { //点击的按钮是当前页滚动到顶部 证明曾经设置过两侧的数据所以不用再次设置
            [midController setData:self.newsArray[index] needRefresh:needRefresh scrollTop:scrollTop contentOffset_Y:0];
            return;
        }
        [leftController setData:self.newsArray[index - 1 ] needRefresh:NO scrollTop:scrollTop contentOffset_Y:[contentOffsets_Y[@(index-1)] doubleValue]];
        [midController setData:self.newsArray[index ] needRefresh:needRefresh scrollTop:scrollTop contentOffset_Y:[contentOffsets_Y[@(index)] doubleValue]];
        [rightController setData:self.newsArray[index + 1 ] needRefresh:NO scrollTop:scrollTop contentOffset_Y:[contentOffsets_Y[@(index+1)] doubleValue]];
    }
}

@end
