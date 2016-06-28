//
//  ViewController.m
//  LoopRoundFigure
//
//  Created by Y杨定甲 on 16/6/27.
//  Copyright © 2016年 damai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>{
    UIPageControl *_pageControl;
}
@property (weak, nonatomic) IBOutlet UIScrollView *runRoundScrollView;

//轮播的图片数组
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSTimer *timer;
@end


#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
@implementation ViewController

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
    
    for (int i = 0; i<3; i++) {
        NSString *imageName=[NSString stringWithFormat:@"Christmas%d.png",i];
        [self.images addObject:imageName];
    }
}

- (void)initScrollView{
    
    CGFloat height = self.runRoundScrollView.frame.size.height;
    self.runRoundScrollView.contentSize = CGSizeMake(3*SCREEN_WIDTH, height);
    self.runRoundScrollView.contentOffset = CGPointMake(0, 0);
    self.runRoundScrollView.delegate = self;
    //添加三张imageView
    for (NSUInteger i = 0; i < self.images.count; i++) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH *i, 0, SCREEN_WIDTH, height)];
        imageV.image = [UIImage imageNamed:self.images[i]];
       
        [self.runRoundScrollView addSubview:imageV];
    }
    //pagecontrol
    CGFloat pageWith = 20*self.images.count;
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-pageWith)/2, 330, pageWith, 20)];
    _pageControl.numberOfPages = self.images.count;
    _pageControl.userInteractionEnabled = NO;
    _pageControl.pageIndicatorTintColor = [UIColor blackColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self.view addSubview:_pageControl];
    [self addTimer];
}

/**
 *  添加定时器
 */
- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 *  移除定时器
 */
- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}
- (void)nextPage
{
    //这是最简单的无限循环，但是如果图片较多。这比较浪费内存。
    if (_pageControl.currentPage ==self.images.count-1) {
        _pageControl.currentPage = 0;
    }else {
        _pageControl.currentPage += 1;
    }
    //滚动的位置
    CGFloat offsetX = _pageControl.currentPage * self.runRoundScrollView.frame.size.width;
    
    [self.runRoundScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}
- (void)dealloc{
    [self removeTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
