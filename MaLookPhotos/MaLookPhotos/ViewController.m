//
//  ViewController.m
//  MaLookPhotos
//
//  Created by Admin on 2018/7/18.
//  Copyright © 2018年 Admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong)UIView  * chooseImageView;
@property(nonatomic,strong)NSMutableArray *arrayData;
@end

@implementation ViewController
-(NSMutableArray *)arrayData{
    if (_arrayData==nil) {
        _arrayData=[NSMutableArray array];
    }
    return _arrayData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUi];
}

-(void)setUpUi{
    //取屏幕宽高
    float width = [UIScreen mainScreen].bounds.size.width;
   self.chooseImageView = [[UIView alloc] init];
    NSArray *imgArray = [[NSArray alloc] initWithObjects:@"1_leirobin.jpg",@"1_leirobin.jpg",@"1_leirobin.jpg",@"1_leirobin.jpg",@"1_leirobin.jpg",nil];
    if (self.arrayData.count==0) {
        
    }
    NSInteger picCount = [imgArray count];
    //定义每个cell图片
    for (int i=0;i<picCount;i++){
        UIImageView *imageCell = [[UIImageView alloc] initWithFrame:CGRectMake(width/3*(i%3), width/3*(i/3)+20, width/3, width/3)];
        imageCell.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[imgArray objectAtIndex:i]]];
        //每当第4个图片时，增加一行，增加整个view的高度
        if (i%3 == 0) {
            [self.chooseImageView setFrame:CGRectMake(0, 100, width, self.chooseImageView.frame.size.height+width/3+20)];
        }
        [self.chooseImageView addSubview:imageCell];
    }
    [self.view addSubview:self.chooseImageView];
}




@end
