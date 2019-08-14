//
//  FPhotoModel.h
//  FAImagePicker
//
//  Created by AoChen on 2019/8/13.
//  Copyright © 2019 Ac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface FPhotoModel : NSObject

// 相簿信息
@property (nonatomic, strong) PHAssetCollection *assetCollection;
// 图片信息(可获取原图)
@property (nonatomic, strong) PHAsset *asset;
// 缩略图片
@property (nonatomic, strong) UIImage *thumbnailImage;
// 状态
@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
