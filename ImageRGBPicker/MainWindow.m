//
//  MainWindow.m
//  ImageRGBPicker
//
//  Created by cloudayc on 5/10/14.
//  Copyright (c) 2014 cloudayc. All rights reserved.
//

#import "MainWindow.h"

#import "MainView.h"

#import "PickerView.h"

#import "SettingViewController.h"
#import "PickerViewManager.h"

@interface MainWindow()
{
    CGPoint imageViewOffset;
}
@property (nonatomic, retain) MainView *displayView;
@property (nonatomic ,retain) NSImageView *imageView;
@property (nonatomic ,retain) SettingViewController *settingVC;
@end

@implementation MainWindow

- (id) initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    if (self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag])
    {
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSTIFFPboardType,NSFilenamesPboardType, nil]];
        
        imageViewOffset.x = 0;
        imageViewOffset.y = 0;
    }
    return self;
}

#pragma mark - mouse event
- (void)mouseEntered:(NSEvent *)theEvent
{
    [[self contentView] addCursorRect:[[self contentView] bounds] cursor:[NSCursor crosshairCursor]];
    TOUCH_LOG;
    
}

- (void)mouseExited:(NSEvent *)theEvent
{
    TOUCH_LOG;
    
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    NSPoint point = [theEvent locationInWindow];
    if ([self checkImageViewArea:point])
    {
//        NSPoint pointInImage = [[self contentView] convertPoint:point toView:_imageView];
        [PickerViewManager sharedPickerViewManager].currentPoint = point;
    }
}

- (void)mouseDown:(NSEvent *)theEvent
{
    TOUCH_LOG;
    
}

- (void)mouseUp:(NSEvent *)theEvent
{
    TOUCH_LOG;
    NSPoint point = [theEvent locationInWindow];
    if ([self checkImageViewArea:point])
    {
        [self addPickerView:point];
    }
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    TOUCH_LOG;
}

- (BOOL)checkImageViewArea:(NSPoint)point
{
    if (!_imageView)
    {
        return NO;
    }
    if (NSPointInRect(point, [_imageView frame]))
    {
        return YES;
    }
    return NO;
}

- (void)addPickerView:(NSPoint)point
{
    if (!_imageView)
        return;
    
    PickerView *view = [[PickerView alloc] initWithFrame:NSMakeRect(point.x, point.y, 50, 50)];
    [[self contentView] addSubview:view];
}

#pragma mark - Pick File Path
- (NSDragOperation)draggingEntered:(id )sender
{
    TOUCH_LOG;
    if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) == NSDragOperationGeneric)
    {
        return NSDragOperationGeneric;
        
    }
    return NSDragOperationNone;
    
}
- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    TOUCH_LOG;
}

- (BOOL)prepareForDragOperation:(id )sender
{
    return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    TOUCH_LOG;
    NSPasteboard *zPasteboard = [sender draggingPasteboard];
    NSArray *zImageTypesAry = [NSArray arrayWithObjects:
                               NSFilenamesPboardType,
                               nil];
    
    NSString *zDesiredType = [zPasteboard availableTypeFromArray:zImageTypesAry];
    
    if ([zDesiredType isEqualToString:NSFilenamesPboardType])
    {
        NSArray *zFileNamesAry = [zPasteboard propertyListForType:@"NSFilenamesPboardType"];
        NSString *path = [zFileNamesAry objectAtIndex:0];
        [self displayImage:path];
        return YES;
    }
    return NO;
}

- (void)displayImage:(NSString *)path
{
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
    CGRect frame = [[self contentView] bounds];
    frame.size = image.size;
    
    frame.origin = imageViewOffset;
    if (_imageView == nil)
    {
        self.imageView = [[NSImageView alloc] initWithFrame:frame];
        [[self contentView] addSubview:_imageView];
        
        self.settingVC = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
        CGRect setFrame = _settingVC.view.frame;
        setFrame.origin.x = frame.origin.x + frame.size.width + 10;
        _settingVC.view.frame = setFrame;
        [[self contentView] addSubview:_settingVC.view];
        
    }
    [_imageView setFrame:frame];
    [_imageView setImage:image];
    
    [PickerViewManager sharedPickerViewManager].currentImageView = _imageView;
}

@end
