//
//  PickerView.h
//  ImageRGBPicker
//
//  Created by cloudayc on 5/13/14.
//  Copyright (c) 2014 cloudayc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum
{
    SAMPLE_POINT_AVERAGE = 0,
    SAMPLE_POINT_CUSTOM,
    SAMPLE_POINT_NONE
}SamplePointType;

@interface PickerView : NSView

@property (nonatomic) CGRect regionFrame;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *comment;

@property (nonatomic) SamplePointType sampleType;
@property (nonatomic) NSInteger sampleCount;

@property (nonatomic, strong) NSMutableArray *customPointsArray;

- (void)setBorderColor:(NSColor *)color;

@end
