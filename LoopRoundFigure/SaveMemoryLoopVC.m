//
//  SaveMemoryLoopVC.m
//  LoopRoundFigure
//
//  Created by Y杨定甲 on 16/6/27.
//  Copyright © 2016年 damai. All rights reserved.
//

#import "SaveMemoryLoopVC.h"


#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
@interface SaveMemoryLoopVC ()<UIScrollViewDelegate>
{
    UIPageControl *_pageControl;
    NSInteger _currentImageIndex;//当前图片索引
    //循环滚动的三个视图
    UIImageView * _leftImageView;
    UIImageView * _centerImageView;
    UIImageView * _rightImageView;
    //用于确定滚动式由人导致的还是计时器到了,系统帮我们滚动的.  YES,则为系统滚动,NO则为客户滚动(ps.在客户端中客户滚动一个广告后,这个广告的计时器要归0并重新计时)
//    BOOL _isTimeUp;
}
@property (weak, nonatomic) IBOutlet UIScrollView *runRoundScrollView;

//轮播的图片数组
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSTimer *timer;
@end



@implementation SaveMemoryLoopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.images = [NSMutableArray new];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initImages];
    [self initScrollView];
}

- (void)initImages{
    
    for (int i = 0; i<5; i++) {
        NSString *imageName=[NSString stringWithFormat:@"Christmas%d.png",i];
        [self.images addObject:imageName];
    }
    CGFloat height = self.runRoundScrollView.frame.size.height;
    _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    _leftImageView.image = [UIImage imageNamed:self.images[4]];
    [self.runRoundScrollView addSubview:_leftImageView];
    
    
    _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, height)];
    _centerImageView.image = [UIImage imageNamed:self.images[0]];
    [self.runRoundScrollView addSubview:_centerImageView];
    
    
    _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, height)];
    _rightImageView.image = [UIImage imageNamed:self.images[1]];
    [self.runRoundScrollView addSubview:_rightImageView];
}

- (void)initScrollView{
    
    CGFloat height = self.runRoundScrollView.frame.size.height;
    self.runRoundScrollView.contentSize = CGSizeMake(3*SCREEN_WIDTH, height);
    self.runRoundScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    self.runRoundScrollView.delegate = self;
    
    
    //pagecontrol
    CGFloat pageWith = 20*self.images.count;
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-pageWith)/2, 330, pageWith, 20)];
    _pageControl.numberOfPages = self.images.count;
    _pageControl.userInteractionEnabled = NO;
    _pageControl.pageIndicatorTintColor = [UIColor blackColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    //由于PageControl这个空间必须要添加在滚动视图的父视图上(添加在滚动视图上的话会随着图片滚动,而达不到效果)
    [self.view addSubview:_pageControl];
    [self addTimer];

}

-(void)addTimer{
    //timer不能直接调用scroll滚动结束的代理。分开设置用于控制用户操作
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)nextPage{
    //首先计时器自动向右滑动
    [self.runRoundScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * 2, 0) animated:YES];
//    _isTimeUp = YES;
    //由于直接调用scrollview协议出来的效果比较生硬，所以还是用timer
//    [self scrollViewDidEndDecelerating:self.runRoundScrollView];
    
    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    //然后判断当前的偏移量
    if (self.runRoundScrollView.contentOffset.x > SCREEN_WIDTH) {//向右滑动
        _currentImageIndex=(_currentImageIndex+1)%self.images.count;
    }else if (self.runRoundScrollView.contentOffset.x < SCREEN_WIDTH){//向左滑动
        _currentImageIndex=(_currentImageIndex+self.images.count-1)%self.images.count;
    }else
    {
        return;
    }
    
    NSInteger leftImageIndex ,rightImageIndex;
    //重新设置左右图片
    leftImageIndex=(_currentImageIndex+self.images.count-1)%self.images.count;
    rightImageIndex=(_currentImageIndex+1)%self.images.count;
    
    _leftImageView.image=[UIImage imageNamed:self.images[leftImageIndex]];
    _rightImageView.image=[UIImage imageNamed:self.images[rightImageIndex]];
    _centerImageView.image = [UIImage imageNamed:self.images[_currentImageIndex]];
    
    //重置偏移量
    self.runRoundScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    _pageControl.currentPage = _currentImageIndex;
    
    
    //每次都重置为NO，用户操作不会经过nextpage
//    _isTimeUp = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //如果用户手动控制图片滚动  则应该取消那个计时器
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:3]];
    
    /*
     [timer setFireDate:[NSDate date]]; //继续。
     [timer setFireDate:[NSDate distantPast]];//开启
     [timer setFireDate:[NSDate distantFuture]];//暂停
     */
    
}

@end
