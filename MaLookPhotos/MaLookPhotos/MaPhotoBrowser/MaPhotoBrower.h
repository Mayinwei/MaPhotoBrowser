//
//  MaPhotoBrower.h
//
//
//  Created by Admin on 2017/9/21.
//  Copyright © 2017年 Mr_yiwnei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MaPhotoBrowerDelegate <NSObject>

-(void)deleteImageWithIndex:(NSInteger )index;

@end

@interface MaPhotoBrower : UIViewController

@property(nonatomic,weak)id<MaPhotoBrowerDelegate> delegate;

//是否隐藏删除按钮
@property(nonatomic,assign)BOOL isHiddenDeleteBtn;


//初始化 <UIImage *>
-(instancetype)initWithImageArray:(NSArray<UIImage *> *)image index:(NSInteger)index;

//发送回调
@property(nonatomic,copy)void(^sendBlock)(BOOL isYuan,UIImage *image);
@end
