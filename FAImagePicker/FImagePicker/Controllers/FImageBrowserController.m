//
//  FImageBrowserController.m
//  FAImagePicker
//
//  Created by AoChen on 2019/8/13.
//  Copyright © 2019 Ac. All rights reserved.
//

#import "FImageBrowserController.h"
#import "FPhotoViewCell.h"
#import "FImagePicker.h"

#define KNaviViewH  64

@interface FImageBrowserController ()<UICollectionViewDataSource,UICollectionViewDelegate,FPhotoViewCellDelegate>

@property (nonatomic, strong) UIView *naviView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIButton *selectBtn;

@end

@implementation FImageBrowserController

- (UIView *)naviView{
    if (!_naviView) {
        _naviView = [[UIView alloc] init];
        _naviView.backgroundColor = FRGB(255, 255, 255, 0.2);
        [self.view addSubview:_naviView];
    }
    return _naviView;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.backgroundColor = [UIColor clearColor];
        [_backBtn setImage:[UIImage imageNamed:@"FImagePicker.bundle/back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.naviView addSubview:_backBtn];
    }
    return _backBtn;
}

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.backgroundColor = [UIColor clearColor];
        [_selectBtn setImage:[UIImage imageNamed:@"FImagePicker.bundle/ico_check_nomal"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"FImagePicker.bundle/ico_check_select"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.naviView addSubview:_selectBtn];
    }
    return _selectBtn;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        CGFloat margin = 0;
        CGFloat itemW = FSCREEN_W - 2*margin;
        CGFloat itemH = FSCREEN_H - 2*margin;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        flowLayout.minimumInteritemSpacing = margin;
        flowLayout.minimumLineSpacing = margin;
        flowLayout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor blackColor];
        [_collectionView registerClass:[FPhotoViewCell class] forCellWithReuseIdentifier:NSStringFromClass([FPhotoViewCell class])];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self refreshSubViewLayout];
    
    [self loadViewData];
}

- (void)refreshSubViewLayout
{
    self.collectionView.frame = CGRectMake(0, 0, FSCREEN_W, FSCREEN_H);
    self.naviView.frame = CGRectMake(0, 0, FSCREEN_W, KNaviViewH);
    self.backBtn.frame = CGRectMake(5, 20 + 7, 30, 30);
    self.selectBtn.frame = CGRectMake(FSCREEN_W - 5 - 40, 20 + 7, 30, 30);
}

- (void)loadViewData
{
    [self refreshViewData];
}


- (void)refreshViewData
{
    FPhotoModel *currentPhotoModel = self.photoArray[_index];
    
    _collectionView.contentOffset = CGPointMake(FSCREEN_W * _index, 0);
    
    self.selectBtn.selected = currentPhotoModel.isSelected;
    
}

#pragma mark - ActionMethod
- (void)backAction:(UIButton *)btn
{
    if (self.photoBlock) {
        self.photoBlock(self.photoArray,self.selectArr);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectBtnAction:(UIButton *)btn
{
    FPhotoModel *photoModel = self.photoArray[_index];
    
    if (self.selectArr.count >= 9) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"不能选中超过9张图片" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:nil];
        return;
    }
    
    photoModel.isSelected = !photoModel.isSelected;
    
    btn.selected = photoModel.isSelected;
    
    if (![self.selectArr containsObject:photoModel]) {
        [self.selectArr addObject:photoModel];
    } else {
        [self.selectArr removeObject:photoModel];
    }
    
}

// MARK:- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FPhotoViewCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    FPhotoModel *photoModel = self.photoArray[indexPath.row];
    cell.selectBtn.hidden = YES;
    cell.photoImageV.contentMode = UIViewContentModeScaleAspectFit;
    cell.photoImageV.image = [FPhotoManager fetchOriginalImageWithAssets:photoModel.asset];
    return cell;
}

// MARK:- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView animateWithDuration:0.4f animations:^{
        self.naviView.frame = CGRectMake(0, self.naviView.frame.origin.y == 0 ? -KNaviViewH : 0, FSCREEN_W, KNaviViewH);
    }];
}

// MARK:- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _index = scrollView.contentOffset.x/FSCREEN_W;
    FPhotoModel *photoModel = self.photoArray[_index];
    _selectBtn.selected = photoModel.isSelected;
}
@end
