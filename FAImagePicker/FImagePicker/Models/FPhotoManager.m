//
//  FPhotoManager.m
//  FAImagePicker
//
//  Created by AoChen on 2019/8/13.
//  Copyright © 2019 Ac. All rights reserved.
//

#import "FPhotoManager.h"

@interface FPhotoManager ()

@property (nonatomic, strong) NSMutableArray *allPhotos;

@end

@implementation FPhotoManager

- (NSMutableArray *)allPhotos{
    if (!_allPhotos) {
        _allPhotos = [NSMutableArray array];
    }
    return _allPhotos;
}

/**
 获取所有图片
 */
+ (NSArray *)getAllPhotos
{
    NSMutableArray *allPhotos = [NSMutableArray array];
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
        [allPhotos addObjectsFromArray:[self enumerateAssetsInAssetCollection:assetCollection]];
    }
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    // 遍历相机胶卷,获取大图
    [allPhotos addObjectsFromArray:[self enumerateAssetsInAssetCollection:cameraRoll]];
    
    return allPhotos;
}

/**
 遍历相簿中的所有图片

 @param assetCollection 相簿
 */
+ (NSArray *)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection
{
    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    NSMutableArray *assetPhotos = [NSMutableArray array];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    for (PHAsset *asset in assets) {
        // 是否要原图
        //        CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        //如果设置size过大的话会出现crash，还有个问题，浏览图片的时候图片模糊的情况
        CGSize targetSize = CGSizeMake(220, 220);
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            NSLog(@"%@",info);
            //数据处理
            FPhotoModel *photoModel = [[FPhotoModel alloc]init];
            photoModel.assetCollection = assetCollection;
            photoModel.thumbnailImage = result;
            photoModel.isSelected = NO;
            photoModel.asset = asset;
            [assetPhotos addObject:photoModel];
        }];
    }
    return assetPhotos;
}

/**
 获取原图

 @param asset 图像
 @return 原图
 */
+ (UIImage *)fetchOriginalImageWithAssets:(PHAsset *)asset
{
    static UIImage *originalImage = nil;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    // 是否要原图
    CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
    // 从asset中获得图片
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        NSLog(@"%@",info);
        originalImage = result;
    }];
    return originalImage;
}


@end
