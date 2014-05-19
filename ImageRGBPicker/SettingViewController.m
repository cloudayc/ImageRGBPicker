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
        [[PickerViewManager sharedPickerViewManager] addObserver:self
                                                      forKeyPath:@"sampleType"
                                                         options:NSKeyValueObservingOptionNew
                                                         context:nil];
        [[PickerViewManager sharedPickerViewManager] addObserver:self
                                                      forKeyPath:@"sampleCount"
                                                         options:NSKeyValueObservingOptionNew
                                                         context:nil];
        
    }
    return self;
}

- (void)awakeFromNib
{
    [sample_type_matrix setTarget:self];
    [sample_type_matrix setAction:@selector(SampleTypeSelection:)];
}

- (void)dealloc
{
    [[PickerViewManager sharedPickerViewManager] removeObserver:self forKeyPath:@"pickerView"];
    [[PickerViewManager sharedPickerViewManager] removeObserver:self forKeyPath:@"currentColor"];
    [[PickerViewManager sharedPickerViewManager] removeObserver:self forKeyPath:@"sampleType"];
    [[PickerViewManager sharedPickerViewManager] removeObserver:self forKeyPath:@"sampleCount"];
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
    
    [sample_count_label setStringValue:[NSString stringWithFormat:@"%ld", pickerView.sampleCount]];
    [table_name_label setStringValue:pickerView.name ? pickerView.name : @""];
    [comment_label setStringValue:pickerView.comment ? pickerView.comment : @""];
    [sample_type_matrix selectCellAtRow:pickerView.sampleType column:0];
}


- (IBAction)codeIt:(id)sender
{
    NSInteger count = [[sample_count_label stringValue] integerValue];
    if (count == 0)
        count = 20;
    
    [[PickerViewManager sharedPickerViewManager] giveCodes];
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
    PickerView *pickerView = [PickerViewManager sharedPickerViewManager].pickerView;
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
    else if ([keyPath isEqualToString:@"sampleType"])
    {
        [sample_type_matrix selectCellAtRow:pickerView.sampleType column:0];
    }
    else if ([keyPath isEqualToString:@"sampleCount"])
    {
        [sample_count_label setStringValue:[NSString stringWithFormat:@"%ld", pickerView.sampleCount]];
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
    else if (textField == sample_count_label)
    {
        if (pickerView.sampleType == SAMPLE_POINT_CUSTOM)
        {
            [sample_count_label setStringValue:[NSString stringWithFormat:@"%ld", pickerView.sampleCount]];
            return;
        }
        pickerView.sampleCount = [[sample_count_label stringValue] integerValue];
    }
}

- (IBAction)SampleTypeSelection:(id)sender
{
    [PickerViewManager sharedPickerViewManager].pickerView.sampleType = (SamplePointType)[sample_type_matrix selectedRow];
}

@end
