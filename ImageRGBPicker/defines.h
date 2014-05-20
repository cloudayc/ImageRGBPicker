//
//  defines.h
//  Xib2objcApp
//
//  Created by cloudayc on 5/20/14.
//  Copyright (c) 2014 cloudayc. All rights reserved.
//

#ifndef Xib2objcApp_defines_h
#define Xib2objcApp_defines_h

//#define TOUCH_LOG NSLog(@"%s", __func__);
#define TOUCH_LOG


#define SAMPLE_KEY @"samples"
#define REGIONS_KEY @"regions"
#define SAMPLE_SIZE @"size"


#define FORMAT_CODE

#ifdef FORMAT_CODE
#define CHAR_S '\t'
#define CHAR_E '\n'
#else
#define CHAR_S 0
#define CHAR_E 0
#endif



#endif
