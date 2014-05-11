//
//  MainView.m
//  ImageRGBPicker
//
//  Created by cloudayc on 5/10/14.
//  Copyright (c) 2014 cloudayc. All rights reserved.
//

#import "MainView.h"

@interface MainView()

@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, retain) NSTrackingArea *tracker;
@end

@implementation MainView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self createTrackingArea];
    }
    return self;
}

- (void)createTrackingArea
{
    int opts = (NSTrackingActiveAlways | NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved);
    NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:[self visibleRect]
                                                        options:opts
                                                          owner:self
                                                       userInfo:nil];
    self.tracker = area;
    [self addTrackingArea:area];
}

- (void)initImageWithPath:(NSString *)path
{
    if (path.length == 0)
        return;
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
    CGRect frame = [self frame];
    frame.size = image.size;
    [self setFrame:frame];
    
    NSImageView *imageView = [[NSImageView alloc] initWithFrame:[self bounds]];
    [imageView setImage:image];
    [self addSubview:imageView];
    
    [self setWantsLayer:YES];
}

- (void)updateTrackingAreas{
    [self removeTrackingArea:_tracker];
    [self createTrackingArea];
    [super updateTrackingAreas];
    NSLog(@"updateTrackingAreas");
}
 
- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];

//    [[NSColor lightGrayColor] setFill];
//    NSRectFill(dirtyRect);
//    
//    self.layer.backgroundColor = [NSColor blueColor].CGColor;
//    self.layer.borderColor = [NSColor grayColor].CGColor;
//    self.layer.borderWidth = 2.f;
}

@end
