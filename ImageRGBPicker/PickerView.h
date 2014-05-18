//
//  PickerView.h
//  ImageRGBPicker
//
//  Created by cloudayc on 5/13/14.
//  Copyright (c) 2014 cloudayc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PickerView : NSView

@property (nonatomic) CGRect regionFrame;

- (void)setBorderColor:(NSColor *)color;

@end
