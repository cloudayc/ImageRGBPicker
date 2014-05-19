//
//  SettingViewController.m
//  ImageRGBPicker
//
//  Created by cloudayc on 5/14/14.
//  Copyright (c) 2014 cloudayc. All rights reserved.
//

#import "SettingViewController.h"
#import "PickerViewManager.h"
#import "PickerView.h"

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

- (void)dealloc
{
    [[PickerViewManager sharedPickerViewManager] removeObserver:self forKeyPath:@"pickerView"];
    [[PickerViewManager sharedPickerViewManager] removeObserver:self forKeyPath:@"currentColor"];
}

- (void)refreshInfo
{
    PickerView *pickerView = [PickerViewManager sharedPickerViewManager].pickerView;
    CGRect frame = pickerView.frame;
    
    [txt_x setStringValue:[NSString stringWithFormat:@"%.2f", frame.origin.x]];
    [txt_y setStringValue:[NSString stringWithFormat:@"%.2f", frame.origin.y]];
    [txt_w setStringValue:[NSString stringWithFormat:@"%.2f", frame.size.width]];
    [txt_h setStringValue:[NSString stringWithFormat:@"%.2f", frame.size.height]];
    
    if (NSEqualRects(pickerView.regionFrame, NSZeroRect))
    {
        [info_label setStringValue:@""];
    }
    else
    {
        NSString *regionFrameString = NSStringFromRect(pickerView.regionFrame);
        regionFrameString = [NSString stringWithFormat:@"Region Frame: \n%@", regionFrameString];
        [info_label setStringValue:regionFrameString];
    }
    
    [table_name_label setStringValue:pickerView.name ? pickerView.name : @""];
    [comment_label setStringValue:pickerView.comment ? pickerView.comment : @""];
}


- (IBAction)codeIt:(id)sender
{
    NSInteger count = [[sample_count_label stringValue] integerValue];
    if (count == 0)
        count = 20;
    
    [[PickerViewManager sharedPickerViewManager] generateSamplePoints:[PickerViewManager sharedPickerViewManager].pickerView.frame sampleCount:count];
}

- (IBAction)pickRegion:(id)sender
{
    PickerView *pickerView = [PickerViewManager sharedPickerViewManager].pickerView;
    pickerView.regionFrame = pickerView.frame;
    
    [self refreshInfo];
}

#pragma mark - notifications

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"pickerView"])
    {
        [self refreshInfo];
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

#pragma mark - delegate
- (void)controlTextDidChange:(NSNotification *)obj
{
    PickerView *pickerView = [PickerViewManager sharedPickerViewManager].pickerView;
    NSTextField *textField = [obj object];
    if (textField == table_name_label)
    {
        pickerView.name = [table_name_label stringValue];
    }
    else if (textField == comment_label)
    {
        pickerView.comment = [comment_label stringValue];
    }
}

@end
