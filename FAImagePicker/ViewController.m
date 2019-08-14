//
//  ViewController.m
//  FAImagePicker
//
//  Created by AoChen on 2019/8/12.
//  Copyright © 2019 Ac. All rights reserved.
//

#import "ViewController.h"
#import "FImagePicker.h"

@interface ViewController ()<FImagePickerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    FImagePickerController *imgPicker = [[FImagePickerController alloc] init];
    imgPicker.delegate = self;
    [self presentViewController:imgPicker animated:YES completion:nil];
}

- (void)fImagePicker:(FImagePickerController *)imagePicker selectPhotos:(NSArray<UIImage *> *)selectPhotos
{
    NSLog(@"%@",selectPhotos);
}


@end
