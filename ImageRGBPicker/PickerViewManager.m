//
//  PickerViewManager.m
//  ImageRGBPicker
//
//  Created by cloudayc on 5/13/14.
//  Copyright (c) 2014 cloudayc. All rights reserved.
//

#import "PickerViewManager.h"

char ctrlStr[100] = {CHAR_E};

char *updateCtrlStr(int cnt)
{
    int i = 1;
    for (; i <= cnt; ++i)
        *(ctrlStr + i) = CHAR_S;
    *(ctrlStr + i) = 0;
    return ctrlStr;
}


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
    NSArray *convertedPoints = nil;
    switch (_pickerView.sampleType) {
        case SAMPLE_POINT_AVERAGE:
        {
            convertedPoints = [self generateSamplePoints:_pickerView];
        }
            break;
        case SAMPLE_POINT_CUSTOM:
        {
            convertedPoints = [self generateCustomSamplePoints:_pickerView];
        }
            break;
        case SAMPLE_POINT_NONE:
        {
            
        }
            break;
            
        default:
            break;
    }
    NSString *code = [self codeForSampleTable:convertedPoints];
    NSString *log = [self codeForCall];
    NSLog(@"%@", code);
    NSLog(@"%@", log);
    [self writeToFile:@"/Users/cloudayc/Desktop/触摸精灵/lualib/config.lua" code:code];
    [self writeToFile:@"/Users/cloudayc/Desktop/触摸精灵/lualib/call.lua" code:log];
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

- (NSMutableArray *)generateSamplePoints:(PickerView *)pickerView
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
//            CGPoint p = NSMakePoint(x, y);
//            NSString *pointString = NSStringFromPoint(p);
//            printf("(%d, %d) ", (int)p.x, (int)p.y);
//            [pointList addObject:pointString];
            CGPoint relative_point = NSMakePoint(x - pickFrame.origin.x, pickFrame.origin.y + pickFrame.size.height - y);
            [pointList addObject:NSStringFromPoint(relative_point)];
//            printf("(%d, %d) ", (int)relative_point.x, (int)relative_point.y);
            
        }
        printf("\n");
    }
    return pointList;
}


- (NSArray *)generateCustomSamplePoints:(PickerView *)pickerView
{
    NSMutableArray *convertedPointsArray = [NSMutableArray array];
    NSArray *customPoints = pickerView.customPointsArray;
    for (NSString *p_str in customPoints) {
        CGPoint point = NSPointFromString(p_str);
        CGPoint convertedPoint = point;
        convertedPoint.y = pickerView.frame.size.height - point.y;
        [convertedPointsArray addObject:NSStringFromPoint(convertedPoint)];
    }
    return convertedPointsArray;
}

#pragma mark - IO
- (void)writeToFile:(NSString *)path code:(NSString *)code
{
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *new_str = [NSString stringWithFormat:@"%@\n%@", str, code];
    [new_str writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark - generate code


- (NSString *)codeForSampleTable:(NSArray *)samplePoints
{
    int tab_count = 0;
    
    NSMutableString *code = [NSMutableString stringWithCapacity:1e3];
    
    if (_pickerView.comment)
    {
        [code appendFormat:@"\n--%@\n", _pickerView.comment];
    }
    NSAssert(_pickerView.name, @"_pickerView.name nil");
    NSAssert(_pickerView.customRegionsArray.count > 0, @"_pickerView.customRegionsArray empty");
//    NSAssert(_pickerView.customPointsArray.count > 0, @"_pickerView.customPointsArray empty");
    
    // root table
    [code appendFormat:@"%@ =%s", _pickerView.name, updateCtrlStr(tab_count)];
    [code appendFormat:@"{%s", updateCtrlStr(++tab_count)];
    
    // region table
    [code appendFormat:@"%@ =%s", REGIONS_KEY, updateCtrlStr(tab_count)];
    [code appendFormat:@"{%s", updateCtrlStr(++tab_count)];
    
    // region list
    NSInteger regionsCnt = _pickerView.customRegionsArray.count;
    for (int i = 0; i < regionsCnt; ++i)
    {
        NSString *regionString = _pickerView.customRegionsArray[i];
        NSRect frame = NSRectFromString(regionString);
        [code appendFormat:
         @"{ x = %03d,%cy = %03d,%cw = %03d,%ch = %03d }%s",
         (int)frame.origin.x,
         CHAR_S,
         (int)frame.origin.y,
         CHAR_S,
         (int)frame.size.width,
         CHAR_S,
         (int)frame.size.height,
         (i + 1) == regionsCnt ? "" : ","];
        [code appendFormat:@"%s",
         (i + 1) == regionsCnt ? updateCtrlStr(--tab_count) : updateCtrlStr(tab_count)];
    }
    [code appendFormat:@"}%s%s", samplePoints.count > 0 ? "," : "", updateCtrlStr(tab_count)];
    // region table end
    
    
    // samples
    if (samplePoints.count > 0)
    {
        // sample size
        [code appendFormat:@"frame = { x = %d,%cy = %d,%cw = %d,%ch = %d },%s",
         (int)_pickerView.frame.origin.x,
         CHAR_S,
         (int)_pickerView.frame.origin.y,
         CHAR_S,
         (int)_pickerView.frame.size.width,
         CHAR_S,
         (int)_pickerView.frame.size.height,
         updateCtrlStr(tab_count)];
        
        // sample points
        [code appendFormat:@"%@ =%s", SAMPLE_KEY, updateCtrlStr(tab_count)];
        [code appendFormat:@"{%s", updateCtrlStr(++tab_count)];
        NSInteger sampleCount = samplePoints.count;
        for (int i = 0; i < sampleCount; ++i)
        {
            NSString *p_str = samplePoints[i];
            NSPoint point = NSPointFromString(p_str);
            int r = random() % 255, g = random() % 255, b = random() % 255;
            [code appendFormat:@"{ x = %03d,%cy = %03d,%cr = %03d,%cg = %03d,%cb = %03d }%s",
             (int)point.x,
             CHAR_S,
             (int)point.y,
             CHAR_S,
             r,
             CHAR_S,
             g,
             CHAR_S,
             b,
             (i + 1) == sampleCount ? "" : ","];
            [code appendFormat:@"%s",
             (i + 1) == sampleCount ? updateCtrlStr(--tab_count) :  updateCtrlStr(tab_count)];
        }
        [code appendFormat:@"}%s", updateCtrlStr(--tab_count)];
    }
    
    // root table end
    [code appendFormat:@"}%s", updateCtrlStr(tab_count)];
    
    return code;
}

- (NSString *)codeForCall
{
    int tab_count = 0;
    
    NSMutableString *log = [[NSMutableString alloc] init];
    [log appendFormat:@"%slocal %@_x, %@_y = lib.find_sample_point( %@, %@.regions, 20 )%s",
     updateCtrlStr(tab_count),
     _pickerView.name,
     _pickerView.name,
     _pickerView.name,
     _pickerView.name,
     updateCtrlStr(tab_count)
     ];
    [log appendFormat:@"if %@_x ~= -1 then%s", _pickerView.name, updateCtrlStr(++tab_count)];
    [log appendFormat:@"lib.log( \"找到 %@ touch\" )%s", _pickerView.comment, updateCtrlStr(tab_count)];
    [log appendFormat:@"local touch_x, touch_y = %@_x + %@.frame.w / 2, %@_y + %@.frame.h / 2%s",
     _pickerView.name,
     _pickerView.name,
     _pickerView.name,
     _pickerView.name,
     updateCtrlStr(tab_count)];
    [log appendFormat:@"lib.touch( touch_x, touch_y )%s",
     updateCtrlStr(tab_count)
     ];
    [log appendFormat:@"mSleep(130)%s", updateCtrlStr(--tab_count)];
    [log appendFormat:@"end%s", updateCtrlStr(tab_count)];
    
    return log;
}

@end
