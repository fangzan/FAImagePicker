//
//  FPhotoManager.h
//  FAImagePicker
//
//  Created by AoChen on 2019/8/13.
//  Copyright © 2019 Ac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPhotoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FPhotoManager : NSObject

/**
 获取所有图片
 */
+ (NSArray *)getAllPhotos;

/**
 获取原图

 @param asset 图像
 @return 原图
 */
+ (UIImage *)fetchOriginalImageWithAssets:(PHAsset *)asset;

@end

NS_ASSUME_NONNULL_END
