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
    
    BOOL _touchFlag;
    
    NSColor *_borderColor;
}


@end

@implementation PickerView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _resizeActive = NO;
        _sampleType = SAMPLE_POINT_AVERAGE;
        _sampleCount = 20;
        self.customPointsArray = [NSMutableArray array];
        self.customRegionsArray = [NSMutableArray array];
        
        [[PickerViewManager sharedPickerViewManager] addObserver:self
                                                      forKeyPath:@"pickerView"
                                                         options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                                         context:nil];
        
        [PickerViewManager sharedPickerViewManager].pickerView = self;
    }
    return self;
}

- (void)dealloc
{
    [[PickerViewManager sharedPickerViewManager] removeObserver:self forKeyPath:@"pickerView"];
}

-(void)mouseDown:(NSEvent *)pTheEvent {
    _originalRect = self.frame;
    
    NSPoint tvarMouseInWindow = [pTheEvent locationInWindow];
    NSPoint tvarMouseInView   = [self convertPoint:tvarMouseInWindow
                                          fromView:nil];
    _pointInWindow = tvarMouseInWindow;
    _pointInView = tvarMouseInView;
    
//    NSLog(@"window: %f %f", tvarMouseInWindow.x, tvarMouseInWindow.y);
//    NSLog(@"view: %f %f", tvarMouseInView.x, tvarMouseInView.y);
    
    _touchFlag = YES;
    [self performSelector:@selector(touchCancelled) withObject:nil afterDelay:0.5];
}
- (void)mouseMoved:(NSEvent *)theEvent
{
    TOUCH_LOG;
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    TOUCH_LOG;
    _resizeActive = YES;
}

- (void)mouseExited:(NSEvent *)theEvent
{
    TOUCH_LOG;
}

- (void)mouseUp:(NSEvent *)theEvent
{
    _resizeActive = NO;
    // just enter
    if ([PickerViewManager sharedPickerViewManager].pickerView == self)
    {
        if (_touchFlag)
        {
            [self mouseClick];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(touchCancelled) object:nil];
            _touchFlag = NO;
        }
    }
    [PickerViewManager sharedPickerViewManager].pickerView = self;
}

- (void)mouseClick
{
    self.sampleType = SAMPLE_POINT_CUSTOM;
    [_customPointsArray addObject:NSStringFromPoint(_pointInView)];
    self.sampleCount = [_customPointsArray count];
    [self setNeedsDisplay:YES];
}

-(void)mouseDragged:(NSEvent *)pTheEvent
{
    [PickerViewManager sharedPickerViewManager].pickerView = self;
    
    NSPoint winPoint = [pTheEvent locationInWindow];
    if (_resizeActive)
    {
        NSPoint offset = NSMakePoint(winPoint.x - _pointInWindow.x, winPoint.y - _pointInWindow.y);
        NSPoint curOrigin = _originalRect.origin;
        curOrigin.y += offset.y;
        NSSize curSize = _originalRect.size;
        curSize.height -= offset.y;
        curSize.width += offset.x;
        
        [self setFrameOrigin:curOrigin];
        
        if (curSize.height > 5 && curSize.width > 5)
        {
            [self setFrameSize:curSize];
        }
    }
    else
    {
        NSPoint superPoint = [[self superview] convertPoint:winPoint fromView:nil];
        superPoint.x -= _pointInView.x;
        superPoint.y -= _pointInView.y;
        [self setFrameOrigin:superPoint];
    }
}

#pragma mark - event handle
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

- (void)touchCancelled
{
    _touchFlag = NO;
}

#pragma mark - draw
- (void)setBorderColor:(NSColor *)color
{
    _borderColor = color;
    self.layer.borderColor = _borderColor.CGColor;
    [self setWantsLayer:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = _borderColor.CGColor;
    
    [[NSColor redColor] set];
    for (NSString *p_str in _customPointsArray)
    {
        NSPoint point = NSPointFromString(p_str);
        [NSBezierPath strokeRect:NSMakeRect(point.x, point.y, 1, 1)];
    }
}

#pragma mark - notifications
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"pickerView"])
    {
        PickerView *newView = change[@"new"];
        PickerView *oldView = change[@"old"];
        if (newView == oldView)
            return;
        [newView setBorderColor:[NSColor redColor]];
        if (oldView && ![oldView isKindOfClass:[NSNull class]])
        {
            [oldView setBorderColor:[NSColor whiteColor]];
        }
    }
}
@end
