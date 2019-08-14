//
//  FImageBrowserController.h
//  FAImagePicker
//
//  Created by AoChen on 2019/8/13.
//  Copyright © 2019 Ac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PhotoBlock)(NSArray *photoArray,NSArray *selectArr);

@interface FImageBrowserController : UIViewController

@property (nonatomic, strong) NSArray *photoArray;

@property (nonatomic, strong) NSMutableArray *selectArr;

@property (nonatomic, assign) NSInteger index;

@property(nonatomic,strong) PhotoBlock photoBlock;

@end

NS_ASSUME_NONNULL_END
