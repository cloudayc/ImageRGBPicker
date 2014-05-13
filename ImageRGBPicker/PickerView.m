//
//  PickerView.m
//  ImageRGBPicker
//
//  Created by cloudayc on 5/13/14.
//  Copyright (c) 2014 cloudayc. All rights reserved.
//

#import "PickerView.h"
#import "PickerViewManager.h"

@interface PickerView()
{
    NSPoint _pointInView;
    NSPoint _pointInWindow;
    
    NSRect _originalRect;
    
    NSTrackingArea *_trackArea;
    
    BOOL _resizeActive;
    
    NSColor *_borderColor;
}
@end

@implementation PickerView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _resizeActive = NO;
        [[PickerViewManager sharedPickerViewManager] addObserver:self
                                                      forKeyPath:@"currentView"
                                                         options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                                         context:nil];
        _borderColor = [NSColor whiteColor];
        
        [PickerViewManager sharedPickerViewManager].currentView = self;
    }
    return self;
}

-(void)mouseDown:(NSEvent *)pTheEvent {
    _originalRect = self.frame;
    
    NSPoint tvarMouseInWindow = [pTheEvent locationInWindow];
    NSPoint tvarMouseInView   = [self convertPoint:tvarMouseInWindow
                                          fromView:nil];
    _pointInWindow = tvarMouseInWindow;
    _pointInView = tvarMouseInView;
    
    NSLog(@"window: %f %f", tvarMouseInWindow.x, tvarMouseInWindow.y);
    NSLog(@"view: %f %f", tvarMouseInView.x, tvarMouseInView.y);
    //    NSSize zDragOffset = NSMakeSize(0.0, 0.0);
    //    NSPasteboard *zPasteBoard;
    
    //    zPasteBoard = [NSPasteboard pasteboardWithName:NSDragPboard];
    //    [zPasteBoard declareTypes:[NSArray arrayWithObject:NSTIFFPboardType]
    //                        owner:self];
    //    [zPasteBoard setData:[self.nsImageObj TIFFRepresentation]
    //                 forType:NSTIFFPboardType];
    //
    //    [self dragImage:self.nsImageObj
    //                 at:tvarMouseInView
    //             offset:zDragOffset
    //              event:pTheEvent
    //         pasteboard:zPasteBoard
    //             source:self
    //          slideBack:YES];
    
    
}
- (void)mouseMoved:(NSEvent *)theEvent
{
    NSLog(@"%s", __func__);
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    _resizeActive = YES;
    NSLog(@"%s", __func__);
}

- (void)mouseExited:(NSEvent *)theEvent
{
    NSLog(@"%s", __func__);
}

- (void)mouseUp:(NSEvent *)theEvent
{
    _resizeActive = NO;
    
    [PickerViewManager sharedPickerViewManager].currentView = self;
}

-(void)mouseDragged:(NSEvent *)pTheEvent
{
    [PickerViewManager sharedPickerViewManager].currentView = self;
    
    NSPoint winPoint = [pTheEvent locationInWindow];
    if (_resizeActive)
    {
        NSPoint offset = NSMakePoint(winPoint.x - _pointInWindow.x, winPoint.y - _pointInWindow.y);
        NSLog(@"offset: %f %f", offset.x, offset.y);
        NSPoint curOrigin = _originalRect.origin;
        curOrigin.y += offset.y;
        NSSize curSize = _originalRect.size;
        curSize.height -= offset.y;
        curSize.width += offset.x;
        
        [self setFrameOrigin:curOrigin];
        
        [self setFrameSize:curSize];
    }
    else
    {
        NSPoint superPoint = [[self superview] convertPoint:winPoint fromView:nil];
        superPoint.x -= _pointInView.x;
        superPoint.y -= _pointInView.y;
        [self setFrameOrigin:superPoint];
    }
    [self setNeedsDisplay:YES];
}

- (NSRect)rightDownCornerRect
{
    NSSize rectSize = NSMakeSize(10, 10);
    NSRect rect = NSMakeRect(self.bounds.size.width - rectSize.width, 0, 0, 0);
    rect.size = rectSize;
    return rect;
}

- (void)resetCursorRects
{
    NSCursor *resizeCursor = [NSCursor resizeLeftRightCursor];
    [self addCursorRect:[self rightDownCornerRect] cursor:resizeCursor];
}

- (void)updateTrackingAreas
{
    if (_trackArea)
    {
        [self removeTrackingArea:_trackArea];
        _trackArea = nil;
    }
    int opt = NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways;
    _trackArea = [[NSTrackingArea alloc] initWithRect:[self rightDownCornerRect]
                                              options:opt
                                                owner:self
                                             userInfo:nil];
    [self addTrackingArea:_trackArea];
}

- (void)setBorderColor:(NSColor *)color
{
    _borderColor = color;
    self.layer.borderColor = _borderColor.CGColor;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = _borderColor.CGColor;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentView"])
    {
        PickerView *newView = change[@"new"];
        PickerView *oldView = change[@"old"];
        if (newView == oldView)
            return;
        [newView setBorderColor:[NSColor redColor]];
        if (oldView)
        {
            [oldView setBorderColor:[NSColor whiteColor]];
        }
    }
}
@end
