//
//  PickerViewManager.h
//  ImageRGBPicker
//
//  Created by cloudayc on 5/13/14.
//  Copyright (c) 2014 cloudayc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PickerView.h"

@interface PickerViewManager : NSObject


@property (nonatomic, strong) PickerView *pickerView;
@property (nonatomic, strong) NSImageView *currentImageView;
@property (nonatomic, readonly) NSColor *currentColor;
@property (nonatomic) NSPoint currentPoint;

+ (PickerViewManager *)sharedPickerViewManager;

- (void)clean;

- (void)setCurrentPoint:(NSPoint)currentPoint;

- (NSArray *)generateSamplePoints:(CGRect)pickFrame sampleCount:(CGFloat)count;

@end
