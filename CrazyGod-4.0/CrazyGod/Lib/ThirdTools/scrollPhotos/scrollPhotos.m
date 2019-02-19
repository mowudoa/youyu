//
//  scrollPhotos.m
//  O2O
//
//  Created by wangxiaowei on 15/5/4.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "scrollPhotos.h"
#import "UIColor+hexColor.h"
//#import "allMerModel.h"
//#import "goodsDetailViewController.h"


@implementation scrollPhotos
{
    NSInteger index;
    NSTimer* timer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    [timer invalidate];
}

#pragma mark - private

//-(void)tapImage:(UITapGestureRecognizer*)tap
//{
//    allMerModel* model = [[allMerModel alloc]init];
//    [model setValuesForKeysWithDictionary:_photos[tap.view.tag-10]];
//    model.salesprice = model.currentprice;
//    
//    UIViewController* VC = (UIViewController*)self.delegate;
//    goodsDetailViewController* root = [[goodsDetailViewController alloc]init];
//    root.model = model;
//    root.commid = [_photos[tap.view.tag-10] objectForKey:@"typeid"];
//    [VC.navigationController pushViewController:root animated:YES];
//}

-(void)createTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollphoto) userInfo:nil repeats:YES];
    [timer setFireDate:[NSDate distantFuture]];
}

-(void)scrollphoto
{
    index++;
    
    if (index == _photos.count) {
        index = 0;
    }
    [_scrollView setContentOffset:CGPointMake(index*SCREEN_WIDTH, 0) animated:YES];
    _pagecontrol.currentPage = index;
}

-(void)startscrollView
{
    [timer setFireDate:[NSDate distantPast]];
}

#pragma mark - getter

-(UIScrollView*)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        for (int i = 0 ; i< _photos.count; i++) {
            UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, self.frame.size.width, self.frame.size.height)];
        //    NSString* imageUrl = [_photos[i] objectForKey:@"photo"];
            
            NSString* imageUrl;
            
            if (self.tag == 10001) {
             
                imageUrl = [NSString stringWithFormat:@"%@%@",defaultImageUrl,_photos[i]];
            }else{
                
            imageUrl = [NSString stringWithFormat:@"%@%@",defaultImageUrl,[_photos[i] objectForKey:@"photo"]];
            }
            
            imageView.tag = 10+i;
            imageView.userInteractionEnabled = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"PLaceHolderpicture"]];
         //   imageView.image = [UIImage imageNamed:@"icon_advertisement"];
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired =1;
            [imageView addGestureRecognizer:tap];
            
            [_scrollView addSubview:imageView];
        }
        _scrollView.contentSize = CGSizeMake(_photos.count*SCREEN_WIDTH, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return  _scrollView;
}

-(UIPageControl*)pagecontrol
{
    if (_pagecontrol == nil) {
        _pagecontrol = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 5, _photos.count * 10, 20)];
        _pagecontrol.currentPage = 0;
        _pagecontrol.pageIndicatorTintColor = [UIColor colorWithHexString:@"#9D9D9D"];
        _pagecontrol.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#FF678F"];
        _pagecontrol.numberOfPages = _photos.count;
    }
    return _pagecontrol;
}

#pragma mark - setter

-(void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    [self createTimer];
    
    [self addSubview:self.scrollView];
    UIView* pageBGView = [[UIView alloc]initWithFrame:CGRectMake(0, _scrollView.frame.size.height - 30, SCREEN_WIDTH, 30)];
    pageBGView.alpha = 0.3;
   // pageBGView.backgroundColor = [UIColor whiteColor];
    [self addSubview:pageBGView];
    [self addSubview:self.pagecontrol];
    _pagecontrol.center = CGPointMake(_scrollView.center.x, pageBGView.center.y);
    
    [self performSelector:@selector(startscrollView) withObject:nil afterDelay:2];
}

//轮播图点击事件
-(void)tapImage:(UITapGestureRecognizer*)tap
{
    
 //   NSLog(@"%ld",tap.view.tag);
}

#pragma marl - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    index = scrollView.contentOffset.x/SCREEN_WIDTH;
    _pagecontrol.currentPage = index;
}

@end
