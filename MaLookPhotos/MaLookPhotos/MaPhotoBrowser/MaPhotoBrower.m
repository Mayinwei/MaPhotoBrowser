//
//  MaPhotoBrower.m
//  
//
//  Created by Admin on 2017/9/21.
//  Copyright © 2017年 Mr_yiwnei. All rights reserved.
//  图片查看器

#import "MaPhotoBrower.h"
#import "MaBrowerCollectionViewCell.h"
#import "LLPhoto.h"
@interface MaPhotoBrower ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,copy)NSMutableArray *imageArray;
@property(nonatomic,strong) UICollectionView *photoCollectionView;
@property(nonatomic,strong)UILabel *numLab;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UIButton *deleteBtn;
@property(nonatomic,strong)UIButton *yuanBtn;
@end

@implementation MaPhotoBrower
-(NSMutableArray *)imageArray{
    if (_imageArray==nil) {
        _imageArray=[NSMutableArray array];
    }
    return _imageArray;
}

-(instancetype)initWithImageArray:(NSArray<UIImage *> *)image index:(NSInteger)index
{
    self = [super init];
    if (self) {
        
        
        self.index=index;
        [self.imageArray addObjectsFromArray:image];
//        UITapGestureRecognizer *tapBg=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelClick)];
//        [self.view addGestureRecognizer:tapBg];
        
        self.view.backgroundColor=[UIColor blackColor];
        //添加控件
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        //相册
        UICollectionView *photoCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height-110) collectionViewLayout:layout];
        [self.view  addSubview:photoCollectionView];
        photoCollectionView.pagingEnabled=YES;
        self.photoCollectionView=photoCollectionView;
        self.photoCollectionView.maximumZoomScale = 2.0;
        self.photoCollectionView.minimumZoomScale = 0.2;
        photoCollectionView.delegate = self;
        photoCollectionView.dataSource = self;
        photoCollectionView.showsHorizontalScrollIndicator = NO;
        [photoCollectionView registerClass:[MaBrowerCollectionViewCell class] forCellWithReuseIdentifier:@"browerColl"];
        
        //底部标识
        
        UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(photoCollectionView.frame), self.view.bounds.size.width, 50)];
        bottomView.backgroundColor=[UIColor blackColor];
        [self.view addSubview:bottomView];
        
//        UILabel *numLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width/2, 40)];
//        self.numLab=numLab;
//        numLab.text=[NSString stringWithFormat:@"%ld/%ld",index+1,self.imageArray.count];
//        numLab.textColor=[UIColor whiteColor];
//        [bottomView addSubview:numLab];
        self.title=[NSString stringWithFormat:@"%ld/%ld",index+1,self.imageArray.count];;
        
        //删除按钮
        UIButton *deleteBtn=[UIButton buttonWithType:0];
        self.deleteBtn=deleteBtn;
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"shanchu"] forState:UIControlStateNormal];
        deleteBtn.tintColor=[UIColor whiteColor];
        deleteBtn.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-20-15, 8.5, 20, 23);
        [deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:deleteBtn];
        //设置偏移量
        [photoCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
        
        UIButton *closeBtn=[UIButton buttonWithType:0];
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        closeBtn.frame=CGRectMake(0, 0,35, 22);
        closeBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        UIBarButtonItem *sendBarItem=[[UIBarButtonItem alloc]initWithCustomView:closeBtn];
        [closeBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem=sendBarItem;
        
        
        UIButton *sendBtn=[UIButton buttonWithType:0];
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        CGFloat w=40;
        CGFloat h=25;
        sendBtn.frame=CGRectMake(bottomView.bounds.size.width-w-15, (bottomView.bounds.size.height-h)/2,w, h);
        sendBtn.titleLabel.font=[UIFont systemFontOfSize:17];
        [bottomView addSubview:sendBtn];
        [sendBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *yuanBtn=[UIButton buttonWithType:0];
        self.yuanBtn=yuanBtn;
        [yuanBtn setTitle:@"原图" forState:UIControlStateNormal];
        [yuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [yuanBtn setImage:[UIImage imageNamed:@"unselected_full"] forState:0];
        [yuanBtn setImage:[UIImage imageNamed:@"selected_full"] forState:UIControlStateSelected];
        yuanBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 7);
        CGFloat wy=70;
        yuanBtn.frame=CGRectMake((bottomView.bounds.size.width-wy)/2, (bottomView.bounds.size.height-h)/2,wy, h);
        yuanBtn.titleLabel.font=[UIFont systemFontOfSize:17];
        [bottomView addSubview:yuanBtn];
        [yuanBtn addTarget:self action:@selector(yuanClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)yuanClick:(UIButton *)sender{
    sender.selected=!sender.selected;
}

-(void)sendClick{
//    NSLog(@"发送");
    if(self.sendBlock!=nil){
        self.sendBlock(self.yuanBtn.selected,self.imageArray[0]);
    }
    [self cancelClick];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor blackColor]] forBarMetrics:UIBarMetricsDefault];
    
    UIColor *color = [UIColor whiteColor];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [UIApplication sharedApplication].statusBarStyle =UIStatusBarStyleLightContent;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(UIImage *)createImageWithColor:(UIColor*)color{
    
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *myImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return myImage;
    
}

//删除图片
-(void)deleteClick
{
    [self.imageArray removeObjectAtIndex:self.index];
    [self.delegate deleteImageWithIndex:self.index];
   
    if (self.imageArray.count==0) {
        [self cancelClick];
        return;
    }
    if (self.index <=self.imageArray.count && self.index>0) {
        //删除的是最后一张
        self.index -=1;
    }else {
        //删除第一张
        self.index=0;
    }
    //设置偏移量
    [self.photoCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self.photoCollectionView reloadData];
//    self.numLab.text = [NSString stringWithFormat:@"%ld/%ld",(unsigned long)self.index+1,(unsigned long)self.imageArray.count];
    self.title=[NSString stringWithFormat:@"%ld/%ld",(unsigned long)self.index+1,(unsigned long)self.imageArray.count];
}

-(void)cancelClick{

    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count;
}


- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MaBrowerCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"browerColl" forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[MaBrowerCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    }
    cell.photo.ll_image=self.imageArray[indexPath.row];
    cell.photo.zoomScale = 1.0;
    return cell;
}

#pragma mark - UICollectionViewDelagate 当图图片滑出屏幕外时，将图片比例重置为原始比例
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    MaBrowerCollectionViewCell *LLCell = (MaBrowerCollectionViewCell *)cell;
    LLCell.photo.zoomScale = 1.0;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.index = (long)scrollView.contentOffset.x/self.view.bounds.size.width;
//    self.numLab.text = [NSString stringWithFormat:@"%ld/%ld",self.index+1,self.imageArray.count];
    self.title=[NSString stringWithFormat:@"%ld/%ld",self.index+1,self.imageArray.count];
}

#pragma mark - UICollectionViewDelegateFlowLayout
//设置大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

-(void)setIsHiddenDeleteBtn:(BOOL)isHiddenDeleteBtn
{
    _isHiddenDeleteBtn=isHiddenDeleteBtn;
    self.deleteBtn.hidden=isHiddenDeleteBtn;
}

@end
