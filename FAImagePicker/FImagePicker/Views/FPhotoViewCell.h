//
//  FPhotoViewCell.h
//  FAImagePicker
//
//  Created by AoChen on 2019/8/13.
//  Copyright © 2019 Ac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPhotoModel.h"
NS_ASSUME_NONNULL_BEGIN
@class FPhotoViewCell;
@protocol FPhotoViewCellDelegate <NSObject>
@optional
- (void)photoViewCell:(FPhotoViewCell *)photoViewCell index:(NSInteger)index;

@end

@interface FPhotoViewCell : UICollectionViewCell

@property (nonatomic, weak) id<FPhotoViewCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *photoImageV;

@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
