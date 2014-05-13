//
//  PickerViewManager.m
//  ImageRGBPicker
//
//  Created by cloudayc on 5/13/14.
//  Copyright (c) 2014 cloudayc. All rights reserved.
//

#import "PickerViewManager.h"

@implementation PickerViewManager

+ (PickerViewManager *)sharedPickerViewManager
{
    static PickerViewManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PickerViewManager alloc] init];
    });
    return instance;
}
@end
