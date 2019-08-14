//
//  FPhotoViewCell.m
//  FAImagePicker
//
//  Created by AoChen on 2019/8/13.
//  Copyright © 2019 Ac. All rights reserved.
//

#import "FPhotoViewCell.h"

@interface FPhotoViewCell ()

@end

@implementation FPhotoViewCell

- (UIImageView *)photoImageV{
    if (!_photoImageV) {
        _photoImageV = [[UIImageView alloc] init];
    }
    return _photoImageV;
}

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.selected = NO;
        [_selectBtn setImage:[UIImage imageNamed:@"FImagePicker.bundle/ico_check_nomal"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"FImagePicker.bundle/ico_check_select"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(selectedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectBtn];
    }
    return _selectBtn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat KSelfM = 3;
    CGFloat KSelfW = CGRectGetWidth(self.frame);
    CGFloat KSelfH = CGRectGetHeight(self.frame);
    
    // 添加图片视图
    self.photoImageV.frame = CGRectMake(KSelfM, KSelfM, KSelfW - 2*KSelfM, KSelfH - 2*KSelfM);
    [self.contentView addSubview:self.photoImageV];
    
    // 添加选中按钮
    CGFloat KSelectBtnW = 20;
    self.selectBtn.frame = CGRectMake(self.frame.size.width - KSelectBtnW - KSelfM, KSelfM, KSelectBtnW, KSelectBtnW);
    [self.contentView addSubview:self.selectBtn];
}

// MARK:- method
- (void)selectedBtnAction:(UIButton *)sender
{
    [self shakeAnimationForView:sender];
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoViewCell:index:)]) {
        [self.delegate photoViewCell:self index:_index];
    }
}

- (void)shakeAnimationForView:(UIView *)sender
{
    // 获取到当前的View
    CALayer *viewLayer = sender.layer;
    // 获取当前View的位置
    CGPoint position = viewLayer.position;
    // 移动的两个终点位置
    CGPoint x = CGPointMake(position.x + 1, position.y);
    CGPoint y = CGPointMake(position.x - 1, position.y);
    // 设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 设置运动形式
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    // 设置开始位置
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    // 设置结束位置
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    // 设置自动反转
    [animation setAutoreverses:YES];
    // 设置时间
    [animation setDuration:.06];
    // 设置次数
    [animation setRepeatCount:3];
    // 添加上动画
    [viewLayer addAnimation:animation forKey:nil];
}


@end
