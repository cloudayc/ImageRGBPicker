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
                                                      forKeyPath:@"currentView"
                                                         options:NSKeyValueObservingOptionNew
                                                         context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGRect frame = [PickerViewManager sharedPickerViewManager].currentView.frame;
    
    [txt_x setStringValue:[NSString stringWithFormat:@"%.2f", frame.origin.x]];
    [txt_y setStringValue:[NSString stringWithFormat:@"%.2f", frame.origin.y]];
    [txt_w setStringValue:[NSString stringWithFormat:@"%.2f", frame.size.width]];
    [txt_h setStringValue:[NSString stringWithFormat:@"%.2f", frame.size.height]];
}
@end
