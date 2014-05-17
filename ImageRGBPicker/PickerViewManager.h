//
//  PickerViewManager.h
//  ImageRGBPicker
//
//  Created by cloudayc on 5/13/14.
//  Copyright (c) 2014 cloudayc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PickerViewManager : NSObject


@property (nonatomic, strong) NSView *pickerView;
@property (nonatomic, strong) NSImageView *currentImageView;
@property (nonatomic, readonly) NSColor *currentColor;
@property (nonatomic) NSPoint currentPoint;

+ (PickerViewManager *)sharedPickerViewManager;

- (void)setCurrentPoint:(NSPoint)currentPoint;

- (NSArray *)generateSamplePoints:(CGRect)pickFrame sampleCount:(CGFloat)count;

@end
