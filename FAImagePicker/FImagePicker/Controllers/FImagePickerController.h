//
//  FImagePickerController.h
//  FAImagePicker
//
//  Created by AoChen on 2019/8/13.
//  Copyright © 2019 Ac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//第一种回调传值
typedef void(^finishToSelectPhotoBlock)(NSArray *photoArray);
@class FImagePickerController;
@protocol FImagePickerDelegate <NSObject>
@optional

- (void)fImagePicker:(FImagePickerController *)imagePicker selectPhotos:(NSArray<UIImage *>*)selectPhotos;

@end

@interface FImagePickerController : UIViewController

@property (nonatomic, weak) id<FImagePickerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
