//
//  SettingViewController.m
//  ImageRGBPicker
//
//  Created by cloudayc on 5/14/14.
//  Copyright (c) 2014 cloudayc. All rights reserved.
//

#import "SettingViewController.h"
#import "PickerViewManager.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[PickerViewManager sharedPickerViewManager] addObserver:self
                                                      forKeyPath:@"pickerView"
                                                         options:NSKeyValueObservingOptionNew
                                                         context:nil];
        [[PickerViewManager sharedPickerViewManager] addObserver:self
                                                      forKeyPath:@"currentColor"
                                                         options:NSKeyValueObservingOptionNew
                                                         context:nil];
        
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"pickerView"])
    {
        CGRect frame = [PickerViewManager sharedPickerViewManager].pickerView.frame;
        
        [txt_x setStringValue:[NSString stringWithFormat:@"%.2f", frame.origin.x]];
        [txt_y setStringValue:[NSString stringWithFormat:@"%.2f", frame.origin.y]];
        [txt_w setStringValue:[NSString stringWithFormat:@"%.2f", frame.size.width]];
        [txt_h setStringValue:[NSString stringWithFormat:@"%.2f", frame.size.height]];
    }
    else if ([keyPath isEqualToString:@"currentColor"])
    {
        NSColor *color = [PickerViewManager sharedPickerViewManager].currentColor;
        if (!color)
            return;
        
        CGFloat r, g, b, a;
        [color getRed:&r green:&g blue:&b alpha:&a];
        [rgba_label setStringValue:[NSString stringWithFormat:@"RGBA(%d, %d, %d, %d)", (int)(r * 255), (int)(g * 255), (int)(b * 255), (int)(a * 255)]];

        [rgba_checkView.layer setBackgroundColor:color.CGColor];
        [rgba_checkView setWantsLayer:YES];
        
        CGPoint currentPoint = [PickerViewManager sharedPickerViewManager].currentPoint;
        [location_label setStringValue:[NSString stringWithFormat:@"X: %.2f Y: %.2f", currentPoint.x, currentPoint.y]];
    }
}


- (IBAction)codeIt:(id)sender
{
    [[PickerViewManager sharedPickerViewManager] generateSamplePoints:[PickerViewManager sharedPickerViewManager].pickerView.frame sampleCount:20];
}
@end
