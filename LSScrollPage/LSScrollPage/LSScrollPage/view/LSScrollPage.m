
//
//  LSScrollPage.m
//  LSScrollPage
//
//  Created by ls on 15/12/28.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSColorButton.h"
#import "LSColorLabel.h"
#import "LSContentController.h"
#import "LSScrollPage.h"
#define Width self.frame.size.width
#define Height self.frame.size.height

#define TitleHeight 40
#define TitleNumbersOfPage 5
#define TitleWidth (Width / TitleNumbersOfPage)
@interface LSScrollPage () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView* titleScrollView; //存放标题的scrollView
@property (nonatomic, strong) NSMutableArray* titleButtons; //存放顶部标题button的数组
@property (nonatomic, weak) UIScrollView* scrollView; //存放内容的scrollView


@property (nonatomic, strong) LSContentController* leftController;
@property (nonatomic, strong) LSContentController* midController;
@property (nonatomic, strong) LSContentController* rightController;

@property (nonatomic, assign) NSInteger currentPage; //当前显示的是第几页
@property (nonatomic, assign) BOOL scrollToRight; //标志是从2Width往中间滑动 还是从0往中间滑动
@property (nonatomic, assign) BOOL manual; //是否是手动设置的ContentOffset
@property (nonatomic, assign) BOOL first; //标志是否是第一次滑动到中间页
@property (nonatomic, strong) NSMutableDictionary* contentOffsets; //存放每个界面的contentOffset

@property (nonatomic, assign) BOOL scrollDirection; // NO 向右  YES向左

//记录两个可变的颜色button在哪个位置
@property (nonatomic, weak) LSColorButton* leftButton;
@property (nonatomic, weak) LSColorButton* rightButton;

@end
static NSInteger lastIndex = 0; //记录在滑动之前的页数
static CGFloat contentOffsetX = 0.0; //记录上次contentOffset.X用来判断是往左侧滑还是右侧滑
@implementation LSScrollPage
- (NSMutableArray*)titleButtons
{
    if (_titleButtons == nil) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.scrollToRight = YES;
        self.first=YES;
        self.titleColor = [UIColor blackColor];
        self.titleFont = [UIFont systemFontOfSize:14];
        [self initViews];
    }
    return self;
}
- (NSMutableDictionary*)contentOffsets
{
    if (!_contentOffsets) {
        _contentOffsets = [NSMutableDictionary dictionary];
    }
    return _contentOffsets;
}

/*
 初始化视图
*/
- (void)initViews
{
    //存放内容的scrollView
    UIScrollView* scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1.0];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.scrollsToTop = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;

    self.leftController = [self addController];
    self.midController = [self addController];
    self.rightController = [self addController];

    //存放标题的scrollView
    UIScrollView* titleScrollView = [[UIScrollView alloc] init];
    titleScrollView.scrollsToTop = NO;
    titleScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:titleScrollView];
    self.titleScrollView = titleScrollView;
}
/*
 创建内容控制器
 */
- (LSContentController*)addController
{
    LSContentController* controller = [[LSContentController alloc] init];
    //当tableView进行刷新数据时禁止滑动
    __weak typeof(self) weakSelf = self;
    controller.actionBlock = ^(BOOL success) {
        weakSelf.scrollView.scrollEnabled = success;
    };
    [self.scrollView addSubview:controller.view];
    return controller;
}
/*
 设置内容控制器view的frame
 */
- (void)setControllerViewFrame
{
    self.leftController.view.frame = CGRectMake(0, 0, Width, Height - TitleHeight);

    if (self.titles.count >= 2) {
        self.midController.view.frame = CGRectMake(Width, 0, Width, Height - TitleHeight);
    }
    else {
        self.midController.view.frame = CGRectZero;
    }

    if (self.titles.count >= 3) {
        self.rightController.view.frame = CGRectMake(Width * 2, 0, Width, Height - TitleHeight);
    }
    else {
        self.rightController.view.backgroundColor = [UIColor redColor];
        self.rightController.view.frame = CGRectZero;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
    contentOffsetX = scrollView.contentOffset.x;
}
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{

    if (self.manual) {
        self.manual = NO;
        return;
    }


    CGPoint point = scrollView.contentOffset;
    CGFloat x = point.x;
    
    NSLog(@"xxxxxxxxxxxxxxxxxxxxxx===%lf",x);
    //在内容UIScrolLView滚动过程中同时滚动上面标题UIScrolLView
    CGPoint contentOffset=CGPointMake(TitleWidth*(self.currentPage-2)+(x-contentOffsetX)/Width*TitleWidth, 0);
    
    if (contentOffset.x>0.000&&contentOffset.x <TitleWidth * (self.titles.count - TitleNumbersOfPage)) {
//        contentOffset.x = (self.titles.count - TitleNumbersOfPage) * TitleWidth;
        NSLog(@"mmmmmmmmmmmmmmmmmmmmmmmpage=====%ld    ==%lf",self.currentPage,contentOffset.x);
        [self.titleScrollView setContentOffset:contentOffset animated:NO];
    }
    
    
    CGFloat scale;
    if (x > 0 && x < Width) {
        scale = x / Width;
    }
    else if (x >= Width && Width < 2 * Width) {
        scale = (x - Width) / Width;
    }
    else {
        scale = (x - 2 * Width) / Width;
    }
    
    
//    NSLog(@"xxxxxxxxxxxx==%lf    %lf", contentOffsetX, x);
    self.leftButton.scale=0.0;
    self.rightButton.scale=0.0;
    [self resetButtonState];
    
    if (x - contentOffsetX > 0.0000) { //往右侧滑动
//        NSLog(@"aaaaaaaaaaaaaaaaaaa");
        if (self.currentPage < self.titles.count - 1) {
            //            NSLog(@"sdfjlskdjnflksdjflksdjfl");
            self.leftButton = self.titleButtons[self.currentPage];
            self.leftButton.type = LSColorButtonTypeLeft;
            self.leftButton.selected = YES;
            self.leftButton.scale = scale;

            self.rightButton = self.titleButtons[self.currentPage + 1];
            self.rightButton.type = LSColorButtonTypeRight;
            self.rightButton.selected = NO;
            self.rightButton.scale = scale;
            
            
        }
        else {
            NSLog(@"scale========%lf", scale);
            self.leftButton = self.titleButtons[self.titles.count - 2];
            self.leftButton.type = LSColorButtonTypeLeft;
            self.leftButton.scale = scale;

            self.rightButton = self.titleButtons[self.titles.count - 1];
            self.rightButton.type = LSColorButtonTypeRight;
            self.rightButton.scale = scale;
        }
    }
    else { //左侧
//        NSLog(@"bbbbbbbbbbbbbbbbbbbb");

        if (self.currentPage == 0) {
            //            NSLog(@"bbbbbbbbbbbbbbbbbbbbbbbbb111111111111111");
            self.leftButton = self.titleButtons[0];
            self.leftButton.type = LSColorButtonTypeLeft;
            self.leftButton.scale = scale;

            self.rightButton = self.titleButtons[1];
            self.rightButton.type = LSColorButtonTypeRight;
            self.rightButton.scale = scale;
        }
        else {
//            NSLog(@"bbbbbbbbbbbbbbbbbbbbbbbbb22222222222222222222");
//            NSLog(@"xxxxxxxxxxxx   page==%ld    %lf", self.currentPage, scale);
            self.leftButton = self.titleButtons[self.currentPage - 1];
            //            self.leftButton.backgroundColor=[UIColor greenColor];
            self.leftButton.type = LSColorButtonTypeLeft;
            self.leftButton.selected = YES;
            self.leftButton.scale = scale;

            self.rightButton = self.titleButtons[self.currentPage];
            self.rightButton.selected = NO;
            //            self.rightButton.backgroundColor=[UIColor orangeColor];
            self.rightButton.type = LSColorButtonTypeRight;
            self.rightButton.scale = scale;
        }
    }
    if (self.titles != nil && x >= Width * 2) { //contentOffset.X>2*Width
        if (self.currentPage >= self.titles.count - 2) {
            if (self.currentPage != self.titles.count - 1) {
                //记录上一页面的contentOffset
                [self saveContentOffset];
                self.currentPage = self.titles.count - 1;
                self.scrollToRight = NO;
                        self.first=YES;
                [self setControllerViewFrame];
                [self relodataNeedRefresh:NO scrollTop:NO];
            }
        }
        else {
            [self saveContentOffset];
            self.currentPage++;
            [self setTitleScrollViewContentOffset];
            [self switchRight];
            point.x = Width;
            [self setControllerViewFrame];
            self.manual = YES;
            [self.scrollView setContentOffset:point];
            [self relodataNeedRefresh:NO scrollTop:NO];
        }
    }
    else if (self.titles != nil && x <= 0) {

        if (self.currentPage <= 1) {
            if (self.currentPage != 0) {
                [self saveContentOffset];
                self.currentPage = 0;
                        self.first=YES;
                self.scrollToRight = YES;
                [self setControllerViewFrame];
                [self relodataNeedRefresh:NO scrollTop:NO];
            }
        }
        else {
            self.currentPage--;
                [self setTitleScrollViewContentOffset];
            [self saveContentOffset];
            [self switchLeft];
            point.x = Width;
            [self setControllerViewFrame];
            self.manual = YES;
            [self.scrollView setContentOffset:point];
            [self relodataNeedRefresh:NO scrollTop:NO];
        }
    }
    else if (x >= Width&&x<2*Width) { //进入中间控制器界面  连续滑动特别快时不会==width 在最后一页滑动到倒数第二页时 滑动不点就会-1  bug
        
        if (self.first) {
            self.first=NO;
            if (self.scrollToRight) {
                [self saveContentOffset];
                self.currentPage++;
                [self setControllerViewFrame]; //此处设置是在count为2时滑到最右侧时就不能滑动了,看不出反弹效果
                [self relodataNeedRefresh:NO scrollTop:NO];
            }
            else {//在最后一页滑动到倒数第二页时会-1  然后回到最后一页时会进入2*Width
//                if (x==Width) {                    
                    [self saveContentOffset];
                    self.currentPage--;
                    [self setControllerViewFrame];
                    [self relodataNeedRefresh:NO scrollTop:NO];
//                }
            }
        }
    }
}
- (void)saveContentOffset
{
    if (lastIndex == 0) {
        [self.contentOffsets setObject:@(self.leftController.tableView.contentOffset.y) forKey:@(lastIndex)];
    }
    else if (lastIndex != self.titles.count - 1) {

        [self.contentOffsets setObject:@(self.midController.tableView.contentOffset.y) forKey:@(lastIndex)];
    }
    else {
        [self.contentOffsets setObject:@(self.rightController.tableView.contentOffset.y) forKey:@(lastIndex)];
    }
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
//    [self setTitleScrollViewContentOffset];
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
//    [self setTitleScrollViewContentOffset];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    [self resetButtonState];
//    [self setTitleScrollViewContentOffset];
    if (lastIndex != self.currentPage) {
        lastIndex = self.currentPage;
        NSLog(@"page===%ld", self.currentPage);
        [self relodataNeedRefresh:YES scrollTop:NO];
        [self setStatusBarScrollTop];
    }
}
/*
 刷新数据
 */
- (void)relodataNeedRefresh:(BOOL)needRefresh scrollTop:(BOOL)scrollTop
{
    if ([self.delegate respondsToSelector:@selector(scrollPage:setDataWithIndex:leftController:midController:rightController:needRefresh:scrollTop:contentOffsets_Y:)]) {
        [self.delegate scrollPage:self setDataWithIndex:self.currentPage leftController:self.leftController midController:self.midController rightController:self.rightController needRefresh:needRefresh scrollTop:scrollTop contentOffsets_Y:self.contentOffsets];
    }
}
/*
 顶部按钮点击
 */
- (void)buttonClick:(UIButton*)button
{
    //点击的是当前页面

        if (button.tag==self.currentPage) { //点击的是当前页按钮
            [self relodataNeedRefresh:NO scrollTop:YES];
            return;
        }

    //点击的不是当前页面

    //保存上一界面contentOffset
    [self saveContentOffset];

    //当点击切换页面时取消上个界面的网络操作
    //同时让scrollView可以滚动
    self.scrollView.scrollEnabled = YES;
    if (self.currentPage == 0) {
        [self.leftController cancelNetworkingOperation];
    }
    else if (self.currentPage != self.titles.count - 1) {
        [self.midController cancelNetworkingOperation];
    }
    else {
        [self.rightController cancelNetworkingOperation];
    }

    self.manual = YES; //滑动事件里标志是自己设置的ContentOffset 不会掉didDrag
    
    NSInteger tag = button.tag;
    lastIndex = self.currentPage = tag;
    
    if (tag == 0) {
        self.scrollToRight = YES;
        self.first=YES;
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
    else if (tag == 1 || tag == self.titles.count - 2) { //在中间
        self.scrollView.contentOffset = CGPointMake(Width, 0);
    }
    else if (tag == self.titles.count - 1) {
        self.scrollToRight = NO;
        self.first=YES;
        self.scrollView.contentOffset = CGPointMake(2 * Width, 0);
    }
    else {
        self.first=NO;
        self.scrollView.contentOffset = CGPointMake(Width, 0);
    }
    [self relodataNeedRefresh:YES scrollTop:NO];
    [self setStatusBarScrollTop];
}
- (void)setTitles:(NSMutableArray*)titles
{
    _titles = titles;

    //设置标题scrollView
    CGFloat width = Width / TitleNumbersOfPage;
    self.titleScrollView.contentSize = CGSizeMake(width * titles.count, 0);
    for (int i = 0; i < titles.count; i++) {
        LSColorButton* titleBtn = [[LSColorButton alloc] init];
        titleBtn.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1.0];
        titleBtn.tag = i;
        titleBtn.titleLabel.font = self.titleFont;
        [titleBtn setTitle:titles[i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:self.titleColor forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        titleBtn.frame = CGRectMake(width * i, 0, width, TitleHeight);
        [titleBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleScrollView addSubview:titleBtn];
        [self.titleButtons addObject:titleBtn];
    }

    self.currentPage = 0; //为什么不放在viewDidLoad里 避免初始化第一个按钮时button数组为空导致不能设置第一个按钮颜色为红色

    [self setStatusBarScrollTop];
    if (titles.count >= 3) {
        self.scrollView.contentSize = CGSizeMake(Width * 3, 0);
    }
    else {
        self.scrollView.contentSize = CGSizeMake(Width * titles.count, 0);
    }
    //设置内容scrollView
    [self setControllerViewFrame];

    if (self.delegate) {
        for (int i = 0; i < self.titles.count; i++) {
            [self.contentOffsets setObject:@(0) forKey:@(i)];
        }
        [self relodataNeedRefresh:YES scrollTop:NO];
    }
}

- (void)setDelegate:(id<LSScrollPageDelegate>)delegate
{
    _delegate = delegate;
    //初始化所有界面的contentOffset为0
    if (self.titles.count) {
        for (int i = 0; i < self.titles.count; i++) {
            [self.contentOffsets setObject:@(0) forKey:@(i)];
        }
        [self relodataNeedRefresh:YES scrollTop:NO];
    }
}
- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    NSLog(@"1111111111111111111111111111111======%ld",self.currentPage);
//    [self setTitleScrollViewContentOffset];
    
    [self resetButtonState];
}
-(void)setTitleScrollViewContentOffsetScroll
{
    
    
    
    
}
- (void)setTitleScrollViewContentOffset
{
    NSLog(@"%s   ======%ld", __func__, self.currentPage);
    CGFloat nameWidth = Width / TitleNumbersOfPage;

    CGFloat x = nameWidth * (_currentPage - 2);
    if (x < 0) {
        x = 0;
        [self.titleScrollView setContentOffset:CGPointMake(x, 0) animated:NO];
        return;
    }
    if (x > nameWidth * (self.titles.count - TitleNumbersOfPage)) {
        x = (self.titles.count - TitleNumbersOfPage) * nameWidth;
    }
    //    [self.titleScrollView scrollRectToVisible:CGRectMake(width * (_currentPage-2), 0, width, TitleHeight) animated:YES];
    [self.titleScrollView setContentOffset:CGPointMake(x, 0) animated:NO];
}


-(void)resetButtonState
{
    if (self.titleButtons) {
        for (int i = 0; i < self.titles.count; i++) {
            LSColorButton* btn = self.titleButtons[i];
            btn.selected = (i == self.currentPage);
            btn.scale=0.0;
        }
    }
    
}
/*
设置点击状态栏tableView可以滚动到顶部
 */
- (void)setStatusBarScrollTop
{
    if (self.currentPage == 0) {
        self.leftController.tableView.scrollsToTop = YES;
        self.midController.tableView.scrollsToTop = NO;
        self.rightController.tableView.scrollsToTop = NO;
    }
    else if (self.currentPage != self.titles.count - 1) {
        self.leftController.tableView.scrollsToTop = NO;
        self.midController.tableView.scrollsToTop = YES;
        self.rightController.tableView.scrollsToTop = NO;
    }
    else {
        self.leftController.tableView.scrollsToTop = NO;
        self.midController.tableView.scrollsToTop = NO;
        self.rightController.tableView.scrollsToTop = YES;
    }
}
- (void)switchLeft
{
    LSContentController* tmp = self.rightController;
    self.rightController = self.midController;
    self.midController = self.leftController;
    self.leftController = tmp;
}
- (void)switchRight
{
    LSContentController* tmp = self.leftController;
    self.leftController = self.midController;
    self.midController = self.rightController;
    self.rightController = tmp;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleScrollView.frame = CGRectMake(0, 0, Width, TitleHeight);
    self.scrollView.frame = CGRectMake(0, TitleHeight, Width, Height - TitleHeight);
    [self setControllerViewFrame]; //此处多设置一遍是因为每当滑动时第一次设置frame就闪动一下，第二次以后设置就好了，所以这里县设置一下解决bug
}
@end
