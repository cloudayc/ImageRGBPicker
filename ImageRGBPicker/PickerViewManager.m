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

static PickerViewManager *instance = nil;
+ (PickerViewManager *)sharedPickerViewManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PickerViewManager alloc] init];
    });
    return instance;
}

- (void)clean
{
    self.currentColor = nil;
    self.currentImageView = nil;
    self.currentColor = nil;
    self.currentPoint = NSZeroPoint;
        
}

- (void)setCurrentPoint:(NSPoint)currentPoint
{
    _currentPoint = currentPoint;
    if ([self checkImageViewArea:currentPoint])
    {
        self.currentColor = [self getImageRGBColor:currentPoint];
    }
}

- (void)giveCodes
{
    switch (_pickerView.sampleType) {
        case SAMPLE_POINT_AVERAGE:
        {
            [self generateSamplePoints:_pickerView];
        }
            break;
        case SAMPLE_POINT_CUSTOM:
        {
            [self generateCustomSamplePoints:_pickerView];
        }
            break;
        case SAMPLE_POINT_NONE:
        {
            
        }
            break;
            
        default:
            break;
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

- (NSArray *)generateSamplePoints:(PickerView *)pickerView
{
    CGRect pickFrame = pickerView.frame;
    NSInteger count = pickerView.sampleCount;
    
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
    CGFloat midFactor = sqrt(count);
    while (midFactor > 1)
    {
        CGFloat tmpFactor = midFactor * midFactor / count;
        if (tmpFactor > closeFactor)
            break;
        midFactor += 1;
    }
    
    CGFloat w_count = midFactor;
    CGFloat h_count = count / midFactor;
    if (width < height)
    {
        w_count = count / midFactor;
        h_count = midFactor;
    }
    NSInteger w_span = width / w_count;
    NSInteger h_span = height / h_count;
    
    
    NSMutableArray *pointList = [NSMutableArray array];
    for (int i = 0, y = pickFrame.origin.y + pickFrame.size.height; i <= h_count; ++i, y -= h_span)
    {
        for (int j = 0, x = pickFrame.origin.x; j <= w_count; ++j, x += w_span)
        {
            CGPoint p = NSMakePoint(x, y);
            NSString *pointString = NSStringFromPoint(p);
//            printf("(%d, %d) ", (int)p.x, (int)p.y);
            [pointList addObject:pointString];
            
            CGPoint relative_point = NSMakePoint(x - pickFrame.origin.x, pickFrame.origin.y + pickFrame.size.height - y);
            printf("(%d, %d) ", (int)relative_point.x, (int)relative_point.y);
            
        }
        printf("\n");
    }
    return pointList;
}


- (NSArray *)generateCustomSamplePoints:(PickerView *)pickerView
{
    NSArray *customPoints = pickerView.customPointsArray;
    for (NSString *p_str in customPoints) {
        CGPoint point = NSPointFromString(p_str);
        CGPoint convertedPoint = point;
        convertedPoint.y = pickerView.frame.size.height - point.y;
        printf("(%d, %d) ", (int)convertedPoint.x, (int)convertedPoint.y);
    }
    return nil;
}

@end
