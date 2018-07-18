//
//  LLPhoto.m
//  LLPhotoBrowser
//
//  Created by zhaomengWang on 17/2/6.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLPhoto.h"



@interface LLPhoto ()<UIScrollViewDelegate>{
    UIImageView *_imageView;
    UIImage     *_currentImage;
    NSMutableArray *_imagesArray;
    CGFloat     _totalTime;
}
@end

@implementation LLPhoto

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.minimumZoomScale = MinScale;
        self.maximumZoomScale = MaxSCale;
        self.backgroundColor  = [UIColor blackColor];
        
        _imagesArray   = [[NSMutableArray alloc] initWithCapacity:1];
        
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        
//        UITapGestureRecognizer *singleClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleClick:)];
//        [self addGestureRecognizer:singleClick];
        
        UITapGestureRecognizer *doubleClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClick:)];
        doubleClick.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleClick];
        
//        [singleClick requireGestureRecognizerToFail:doubleClick];
    }
    return self;
}

#pragma mark - 设置当前显示的图片
- (void)setLl_image:(id)ll_image {
    
    if (_imagesArray.count > 1) {
        _totalTime = 0;
        [_imageView stopAnimating];
        [_imagesArray removeAllObjects];
    }
    
    _ll_image = ll_image;
    _imageView.image = nil;
//    [_imagesArray addObject:ll_image];
    if ([ll_image isKindOfClass:[UIImage class]]) {
        _currentImage = (UIImage *)ll_image;
        [self layoutImageView];
    }
    
}



//自适应图片的宽高比
- (void)layoutImageView {
    CGRect imageFrame;
    if (_currentImage.size.width > self.bounds.size.width || _currentImage.size.height > self.bounds.size.height) {
        CGFloat imageRatio = _currentImage.size.width/_currentImage.size.height;
        CGFloat photoRatio = self.bounds.size.width/self.bounds.size.height;
        
        if (imageRatio > photoRatio) {
            imageFrame.size = CGSizeMake(self.bounds.size.width, self.bounds.size.width/_currentImage.size.width*_currentImage.size.height);
            imageFrame.origin.x = 0;
            imageFrame.origin.y = (self.bounds.size.height-imageFrame.size.height)/2.0;
        }
        else {
            imageFrame.size = CGSizeMake(self.bounds.size.height/_currentImage.size.height*_currentImage.size.width, self.bounds.size.height);
            imageFrame.origin.x = (self.bounds.size.width-imageFrame.size.width)/2.0;
            imageFrame.origin.y = 0;
        }
    }
    else {
        imageFrame.size = _currentImage.size;
        imageFrame.origin.x = (self.bounds.size.width-_currentImage.size.width)/2.0;
        imageFrame.origin.y = (self.bounds.size.height-_currentImage.size.height)/2.0;
    }
    _imageView.frame = imageFrame;
    _imageView.image = _currentImage;
    if (_imagesArray.count > 1) {
        [_imageView setAnimationImages:_imagesArray];
        [_imageView setAnimationDuration:_totalTime];
        [_imageView setAnimationRepeatCount:LONG_MAX];
        [_imageView startAnimating];
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat offsetX = (self.bounds.size.width>self.contentSize.width)?(self.bounds.size.width-self.contentSize.width)*0.5:0.0;
    CGFloat offsetY = (self.bounds.size.height>self.contentSize.height)?(self.bounds.size.height-self.contentSize.height)*0.5:0.0;
    _imageView.center = CGPointMake(scrollView.contentSize.width*0.5+offsetX, scrollView.contentSize.height*0.5+offsetY);
}

#pragma mark - 手势交互
////单击
//- (void)singleClick:(UITapGestureRecognizer *)gestureRecognizer {
//    if ([self.ll_delegate respondsToSelector:@selector(singleClickWithPhoto:)]) {
//        [self.ll_delegate singleClickWithPhoto:self];
//    }
//    else {
//        [self removeFromSuperview];
//    }
//}

//双击
- (void)doubleClick:(UITapGestureRecognizer *)gestureRecognizer {
    
    if (self.zoomScale > MinScale) {
        [self setZoomScale:MinScale animated:YES];
    } else {
        CGPoint touchPoint = [gestureRecognizer locationInView:_imageView];
        CGFloat newZoomScale = self.maximumZoomScale;
        CGFloat xsize = self.frame.size.width/newZoomScale;
        CGFloat ysize = self.frame.size.height/newZoomScale;
        [self zoomToRect:CGRectMake(touchPoint.x-xsize/2, touchPoint.y-ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)dealloc {
    NSLog(@"释放");
}

@end
