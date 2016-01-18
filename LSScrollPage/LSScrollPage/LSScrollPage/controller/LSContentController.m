

//
//  LSContentController.m
//  LSScrollPage
//
//  Created by ls on 15/12/28.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSContentController.h"
@interface LSContentController()



@property (nonatomic, strong) NSTimer *timer;
@end
@implementation LSContentController
-(void)viewDidLoad
{
}
-(void)setData:(NewsModel*)newsModel needRefresh:(BOOL)needRefresh scrollTop:(BOOL)scrollTop contentOffset_Y:(CGFloat)contentOffset_Y
{
    [self.tableView setContentOffset:CGPointMake(0, contentOffset_Y)];
    if (scrollTop) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return;
    }
    if (needRefresh) {//滑动结束
        self.newsModel=newsModel;
        //请求更多数据
        

        [self.tableView reloadData];
        
    }else {//只是滑动过程中设置数据并不会加载新数据
        self.newsModel=newsModel;
        [self.tableView reloadData];
    }
    
    
}
#pragma mark - 停止所有网络操作
-(void)cancelNetworkingOperation
{
    [self.timer invalidate];
    self.timer=nil;
    NSLog(@"%s",__func__);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsModel.newsArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.textLabel.textAlignment=NSTextAlignmentLeft;
        cell.detailTextLabel.textAlignment=NSTextAlignmentRight;
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.detailTextLabel.text=[NSString stringWithFormat:@"  %@ ",self.newsModel.newsArray[indexPath.row]];
    return cell;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat y=self.tableView.contentOffset.y;
    if (y<-20) {//此处是模拟加载网络请求 根据个人需求将代码替换 来禁止LSScrollPage禁止滑动
        if (self.actionBlock) {
            self.actionBlock(NO);
            if (self.timer==nil) {
                self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startRefresh) userInfo:nil repeats:NO];
            }
        }
    }
}
/*
 此处是模拟请求成功 来通知LSScrollPage可以滑动
 */
-(void)startRefresh
{
    NSInteger count=self.newsModel.newsArray.count;
    for (int i=0; i<5; i++) {
        [self.newsModel.newsArray addObject:[NSString stringWithFormat:@"%@%ld",[[NSString stringWithFormat:@"%@",self.newsModel.newsArray[0]] substringToIndex:4],count+i]];
    }
    
    [self.tableView reloadData];
    [self.timer invalidate];
    self.timer=nil;
    if (self.actionBlock) {
        self.actionBlock(YES);
    }
    
}
@end
