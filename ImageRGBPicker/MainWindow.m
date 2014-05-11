//
//  MainWindow.m
//  ImageRGBPicker
//
//  Created by cloudayc on 5/10/14.
//  Copyright (c) 2014 cloudayc. All rights reserved.
//

#import "MainWindow.h"

#import "MainView.h"

@interface MainWindow()
{
    CGPoint imageViewOffset;
}
@property (nonatomic, retain) MainView *displayView;
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
    NSLog(@"%s", __func__);
    
}

- (void)mouseExited:(NSEvent *)theEvent
{
    NSLog(@"%s", __func__);
    
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    NSPoint point = [theEvent locationInWindow];
    [self getImageRGBColor:point];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    NSLog(@"%s", __func__);
    
}

- (void)mouseUp:(NSEvent *)theEvent
{
    NSLog(@"%s", __func__);
    
}

#pragma mark - handle the image
- (BOOL)checkImageViewArea:(NSPoint)point
{
    NSImageView *imageView = [[self contentView] viewWithTag:99];
    if (!imageView)
    {
        NSLog(@"NO image !");
        return NO;
    }
    CGRect frame = [imageView frame];
    if (point.x < frame.origin.x
        || point.x > frame.origin.x + frame.size.width
        || point.y < frame.origin.y
        || point.y > frame.origin.y + frame.size.height)
    {
        return NO;
    }
    [NSCursor crosshairCursor];
    return YES;
}

- (NSInteger)color255:(CGFloat)value
{
    return (NSInteger)(value * 255);
}

- (void)getImageRGBColor:(NSPoint)point
{
    if ([self checkImageViewArea:point])
    {
        CGPoint pointInImage;
        pointInImage.x = point.x - imageViewOffset.x;
        pointInImage.y = point.y - imageViewOffset.y;
        NSLog(@"坐标(%ld, %ld)", (NSInteger)pointInImage.x, (NSInteger)pointInImage.y);
        NSImageView *imageView = [[self contentView] viewWithTag:99];
        NSImage *image = [imageView image];
        
        NSBitmapImageRep *rawImage = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
        NSColor *color = [rawImage colorAtX:point.x y:[imageView bounds].size.height - point.y];
//        [rawImage setColor:[NSColor redColor] atX:point.x y:point.y];
//        [image addRepresentation:rawImage];
//        [imageView setImage:image];
        CGFloat r, g, b, a;
        [color getRed:&r green:&g blue:&b alpha:&a];
        [[self contentView] layer].backgroundColor = color.CGColor;
        [[self contentView] setWantsLayer:YES];
        NSLog(@"RGB(%ld, %ld, %ld), A(%ld),", [self color255:r], [self color255:g], [self color255:b], [self color255:a]);
    }
}


#pragma mark - Pick File Path
- (NSDragOperation)draggingEntered:(id )sender
{
    NSLog(@"%s", __func__);
    if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) == NSDragOperationGeneric)
    {
        return NSDragOperationGeneric;
        
    }
    return NSDragOperationNone;
    
}
- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    NSLog(@"%s", __func__);
}

- (BOOL)prepareForDragOperation:(id )sender
{
    return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSLog(@"%s", __func__);
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
    NSImageView *imageView = [[self contentView] viewWithTag:99];
    if (imageView == nil)
    {
        imageView = [[NSImageView alloc] initWithFrame:frame];
        [imageView setTag:99];
        [[self contentView] addSubview:imageView];
//        NSCursor *cursor = [NSCursor crosshairCursor];
////        [imageView resetCursorRects];
//        [imageView addCursorRect:[imageView bounds] cursor:cursor];
//        [cursor setOnMouseEntered:YES];
    }
    [imageView setFrame:frame];
    [imageView setImage:image];
    
}

@end
