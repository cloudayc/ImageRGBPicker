//
//  PickerViewManager.m
//  ImageRGBPicker
//
//  Created by cloudayc on 5/13/14.
//  Copyright (c) 2014 cloudayc. All rights reserved.
//

#import "PickerViewManager.h"

@interface PickerViewManager()

@property (nonatomic, strong) NSColor *currentColor;

@end

@implementation PickerViewManager

+ (PickerViewManager *)sharedPickerViewManager
{
    static PickerViewManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PickerViewManager alloc] init];
    });
    return instance;
}

- (void)setCurrentPoint:(NSPoint)currentPoint
{
    _currentPoint = currentPoint;
    if ([self checkImageViewArea:currentPoint])
    {
        self.currentColor = [self getImageRGBColor:currentPoint];
    }
}

#pragma mark - handle the image

- (BOOL)checkImageViewArea:(NSPoint)point
{
    if (!_currentImageView)
    {
        return NO;
    }
    if (NSPointInRect(point, [_currentImageView frame]))
    {
        return YES;
    }
    return NO;
}

- (NSColor *)getImageRGBColor:(NSPoint)pointInImage
{
    NSImage *image = [_currentImageView image];
    NSBitmapImageRep *rawImage = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
    return [rawImage colorAtX:pointInImage.x y:[_currentImageView bounds].size.height - pointInImage.y];
}

- (NSArray *)generateSamplePoints:(CGRect)pickFrame sampleCount:(CGFloat)count
{
    CGFloat width = pickFrame.size.width;
    CGFloat height = pickFrame.size.height;
    
    if (count <= 1)
    {
        count = width * height * count;
    }
    
    if (width < height)
    {
        CGFloat t = width;
        width = height;
        height = t;
    }
    CGFloat closeFactor = width / height;
    CGFloat area = width * height / count;
    CGFloat midFactor = sqrt(area);
    while (midFactor > 1)
    {
        CGFloat tmpFactor = midFactor * midFactor / area;
        if (tmpFactor > closeFactor)
            break;
        midFactor += 1;
    }
    CGFloat w_len = midFactor;
    CGFloat h_len = area / midFactor;
    if (width < height)
    {
        w_len = area / midFactor;
        h_len = midFactor;
    }
    NSInteger w_count = width / w_len;
    NSInteger h_count = height / h_len;
    
    NSMutableArray *pointList = [NSMutableArray array];
    for (int i = 0, y = pickFrame.origin.y; i < h_count; ++i, y += h_len)
    {
        for (int j = 0, x = pickFrame.origin.x; j < w_count; ++j, x += w_len)
        {
            CGPoint p = NSMakePoint(x, y);
            NSString *pointString = NSStringFromPoint(p);
            printf("(%d, %d) ", (int)p.x, (int)p.y);
//            NSLog(@"%@ ", pointString);
            [pointList addObject:pointString];
        }
        printf("\n");
    }
    return pointList;
}


@end
