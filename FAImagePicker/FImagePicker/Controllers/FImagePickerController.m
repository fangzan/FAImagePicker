//
//  FImagePickerController.m
//  FAImagePicker
//
//  Created by AoChen on 2019/8/13.
//  Copyright © 2019 Ac. All rights reserved.
//

#import "FImagePickerController.h"
#import "FImageBrowserController.h"
#import "FPhotoViewCell.h"
#import "FImagePicker.h"

@interface FImagePickerController ()<UICollectionViewDataSource,UICollectionViewDelegate,FPhotoViewCellDelegate>

@property (nonatomic, strong) NSArray *photoArray;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *originalBtn;
@property (nonatomic, strong) UIButton *sendBtn;

@end

@implementation FImagePickerController

- (NSArray *)photoArray{
    if (!_photoArray) {
        _photoArray = [NSArray array];
    }
    return _photoArray;
}

- (NSMutableArray *)selectArr{
    if (!_selectArr) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        CGFloat margin = 2;
        CGFloat itemW = (FSCREEN_W - margin * 5)/4;
        CGFloat itemH = itemW;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        flowLayout.minimumInteritemSpacing = margin;
        flowLayout.minimumLineSpacing = margin;
        flowLayout.sectionInset = UIEdgeInsetsMake(0.f, margin, margin, margin);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[FPhotoViewCell class] forCellWithReuseIdentifier:NSStringFromClass([FPhotoViewCell class])];
    }
    return _collectionView;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.backgroundColor = [UIColor clearColor];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.backgroundColor = [UIColor redColor];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (UIButton *)originalBtn{
    if (!_originalBtn) {
        _originalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _originalBtn.backgroundColor = [UIColor clearColor];
        _originalBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_originalBtn setTitle:@"原图" forState:UIControlStateNormal];
        [_originalBtn setImage:[UIImage imageNamed:@"FImagePicker.bundle/ico_check_nomal"] forState:UIControlStateNormal];
        [_originalBtn setImage:[UIImage imageNamed:@"FImagePicker.bundle/ico_check_select"] forState:UIControlStateSelected];
        [_originalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_originalBtn addTarget:self action:@selector(originalAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _originalBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:238/256.f green:238/256.f blue:238/256.f alpha:1];
    
    self.photoArray = [FPhotoManager getAllPhotos];
    
    [self setupUI];
}

- (void)setupUI
{
    UIView *topBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FSCREEN_W, 64)];
    topBarView.backgroundColor = [UIColor lightTextColor];
    [self.view addSubview:topBarView];
    
    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake((FSCREEN_W - 150)/2, 20 + 7, 150, 30)];
    titleLB.text = @"所有照片";
    titleLB.textColor = [UIColor blackColor];
    titleLB.font = [UIFont systemFontOfSize:18];
    titleLB.textAlignment = NSTextAlignmentCenter;
    [topBarView addSubview:titleLB];
    
    [topBarView addSubview:self.closeBtn];
    self.closeBtn.frame = CGRectMake(FSCREEN_W - 7 - 50, 20 + 7, 50, 30);
    
    UIView *bottomBarView = [[UIView alloc] initWithFrame:CGRectMake(0, FSCREEN_H - 44, FSCREEN_W, 44)];
    bottomBarView.backgroundColor = [UIColor lightTextColor];
    [self.view addSubview:bottomBarView];
    
    [bottomBarView addSubview:self.sendBtn];
    self.sendBtn.frame = CGRectMake(FSCREEN_W - 7 - 60, 7, 60, 30);
    self.sendBtn.layer.cornerRadius = 15;
    
    [bottomBarView addSubview:self.originalBtn];
    self.originalBtn.frame = CGRectMake(15 , 7, 60, 30);
    self.originalBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - 9/2);
    self.originalBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, - 9/2, 0.0, 0.0);
    
    
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(topBarView.frame), FSCREEN_W, CGRectGetMinY(bottomBarView.frame) - CGRectGetMaxY(topBarView.frame));
    [self.view addSubview:self.collectionView];
}

// MARK:- method
- (void)closeAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fImagePicker:selectPhotos:)]) {
        NSMutableArray *selectImges = [NSMutableArray array];
        if (self.originalBtn.isSelected) {// 发送原图
            for (FPhotoModel *photoModel in self.selectArr) {
                [selectImges addObject:[FPhotoManager fetchOriginalImageWithAssets:photoModel.asset]];
            }
        } else {// 发送缩略图
            for (FPhotoModel *photoModel in self.selectArr) {
                [selectImges addObject:photoModel.thumbnailImage];
            }
        }
        [self.delegate fImagePicker:self selectPhotos:selectImges];
    }
}

- (void)originalAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FPhotoViewCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    FPhotoModel *photoModel = self.photoArray[indexPath.row];
    cell.selectBtn.selected = photoModel.isSelected;
    cell.photoImageV.image = photoModel.thumbnailImage;
    cell.index = indexPath.row;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FImageBrowserController *browserVC = [[FImageBrowserController alloc]init];
    browserVC.photoArray = self.photoArray;
    browserVC.selectArr = self.selectArr;
    browserVC.index = indexPath.row;
    browserVC.photoBlock = ^(NSArray * _Nonnull photoArray, NSArray * _Nonnull selectArr) {
        self.photoArray = photoArray;
        self.selectArr = [NSMutableArray arrayWithArray:selectArr];
        [self.collectionView reloadData];
    };
    [self presentViewController:browserVC animated:YES completion:nil];
}

// MARK:- FPhotoViewCellDelegate
-(void)photoViewCell:(FPhotoViewCell *)photoViewCell index:(NSInteger)index
{
    FPhotoModel *photoModel = self.photoArray[index];
    
    if (self.selectArr.count >= 9) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"不能选中超过9张图片" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:nil];
        return;
    }
    photoModel.isSelected = !photoModel.isSelected;
    
    if (![self.selectArr containsObject:photoModel]) {
        [self.selectArr addObject:photoModel];
    } else {
        [self.selectArr removeObject:photoModel];
    }
    
    [self.collectionView reloadData];
}

@end
