//
//  SettingViewController.h
//  ImageRGBPicker
//
//  Created by cloudayc on 5/14/14.
//  Copyright (c) 2014 cloudayc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SettingViewController : NSViewController
{
    IBOutlet NSView *rgba_checkView;
    IBOutlet NSTextField *location_label;
    IBOutlet NSTextField *rgba_label;
    
    IBOutlet NSTextField *txt_x;
    IBOutlet NSTextField *txt_y;
    IBOutlet NSTextField *txt_w;
    IBOutlet NSTextField *txt_h;
    
    IBOutlet NSTextField *sample_count_label;
    
    IBOutlet NSTextField *table_name_label;
    IBOutlet NSTextField *comment_label;
    
    IBOutlet NSMatrix *sample_type_matrix;
    
    IBOutlet NSTextField *info_label;
}

- (IBAction)codeIt:(id)sender;
- (IBAction)pickRegion:(id)sender;

- (IBAction)SampleTypeSelection:(id)sender;

@end
