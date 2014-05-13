//
//  PickerViewManager.h
//  ImageRGBPicker
//
//  Created by cloudayc on 5/13/14.
//  Copyright (c) 2014 cloudayc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PickerViewManager : NSObject


@property (nonatomic, strong) NSView *currentView;

+ (PickerViewManager *)sharedPickerViewManager;

@end
