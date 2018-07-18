//
//  MaBrowerCollectionViewCell.m
//  
//
//  Created by Admin on 2017/9/21.
//  Copyright © 2017年 Mr_yiwnei. All rights reserved.
//

#import "MaBrowerCollectionViewCell.h"
#import "LLPhoto.h"
@implementation MaBrowerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect rect = self.bounds;
        rect.size.width -= 10;
        rect.origin.x = 5;
        _photo = [[LLPhoto alloc] initWithFrame:rect];
        _photo.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_photo];
    }
    return self;
}

- (void)layoutSubviews {
    _photo.zoomScale = 1.0;
    _photo.contentSize = _photo.bounds.size;
}
@end
