//
//  ViewController.m
//  UIStrollerView
//
//  Created by EaseMob on 16/6/16.
//  Copyright © 2016年 EaseMob. All rights reserved.
//

#import "ViewController.h"

//屏幕宽高
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//rgb
#define My_Color(a,b,c) [UIColor colorWithRed:(a)/255.0f green:(b)/255.0f blue:(c)/255.0f alpha:1.0]
#define IMAGEVIEW_COUNT 3

@interface ViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIImageView *_leftImageView;
    UIImageView *_centerImageView;
    UIImageView *_rightImageView;
    UIPageControl *_pageControl;
    UILabel *_label;
    int _currentImageIndex;//当前图片索引
    int _imageCount;//图片总数
    NSMutableArray *_dataArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self loadImageData];
    [self addScrollView];
    [self addImageView];
    [self addPageControl];
    [self addLabel];
    [self setDefaultImage];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)loadImageData {
     _dataArray = [[NSMutableArray alloc]init];
    for (int i = 0; i <8; i++) {
        NSString *string  = [NSString stringWithFormat:@"%d.jpg",i];
        [_dataArray addObject:string];
    }
    _imageCount = (int)[_dataArray count];
}

- (void)addScrollView {
    _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_scrollView];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(IMAGEVIEW_COUNT * SCREEN_WIDTH, SCREEN_HEIGHT);
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = YES;
}

- (void)addImageView {
    _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_leftImageView];
    _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _centerImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_centerImageView];
    _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(2*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_rightImageView];
}

- (void)setDefaultImage {
    _leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",_imageCount-1]];
    _centerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",0]];
    _rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",1]];
    _currentImageIndex = 0;
    _pageControl.currentPage = _currentImageIndex;
    NSString *string = [NSString stringWithFormat:@"%d.jpg",_currentImageIndex];
    _label.text = string;
}

- (void)addPageControl {
    _pageControl = [[UIPageControl alloc]init];
    CGSize size = [_pageControl sizeForNumberOfPages:_imageCount];
    _pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
    _pageControl.center = CGPointMake(SCREEN_HEIGHT/2, SCREEN_HEIGHT-100);
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:193/255.0 green:219/255.0 blue:249/255.0 alpha:1];
    _pageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:0 green:150/255.0 blue:1 alpha:1];
    _pageControl.numberOfPages = _imageCount;
    [self.view addSubview:_pageControl];
}
- (void)addLabel {
    _label=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH,30)];
    _label.textAlignment=NSTextAlignmentCenter;
    _label.textColor=[UIColor colorWithRed:0 green:150/255.0 blue:1 alpha:1];
    
    [self.view addSubview:_label];
}

-(void)reloadImage{
    int leftImageIndex,rightImageIndex;
    CGPoint offset=[_scrollView contentOffset];
    if (offset.x>SCREEN_WIDTH) { //向右滑动
        _currentImageIndex=(_currentImageIndex+1)%_imageCount;
    }else if(offset.x<SCREEN_WIDTH){ //向左滑动
        _currentImageIndex=(_currentImageIndex+_imageCount-1)%_imageCount;
    }
    //UIImageView *centerImageView=(UIImageView *)[_scrollView viewWithTag:2];
    _centerImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",_currentImageIndex]];
    
    //重新设置左右图片
    leftImageIndex=(_currentImageIndex+_imageCount-1)%_imageCount;
    rightImageIndex=(_currentImageIndex+1)%_imageCount;
    _leftImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",leftImageIndex]];
    _rightImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",rightImageIndex]];
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self reloadImage];
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    //设置分页
    _pageControl.currentPage=_currentImageIndex;
    //设置描述
    NSString *imageName=[NSString stringWithFormat:@"%i.jpg",_currentImageIndex];
    _label.text= imageName;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
