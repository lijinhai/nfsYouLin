//
//  HeaderFile.h
//  Test2
//
//  Created by Macx on 16/5/30.
//  Copyright © 2016年 Macx. All rights reserved.
//

#ifndef HeaderFile_h
#define HeaderFile_h


#define PADDING 10
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

#define imageTag 2000
//#define POST_URL @"https://123.57.9.62/youlin/api1.0/?"
#define POST_URL @"https://www.youlinzj.cn/youlin/api1.0/?"

#define APP_URL @"https://itunes.apple.com/cn/lookup?id=1142034200"

#define BackgroundColor [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:240.0/255.0 alpha:1]
#define MainColor [UIColor colorWithRed:255/255.0 green:222/255.0 blue:31/255.0 alpha:1]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#endif /* HeaderFile_h */
