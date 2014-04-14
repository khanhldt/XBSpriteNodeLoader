//
//  XBSpriteNodeLoader_CircleBodySource.h
//  XBSpriteNodeLoader
//
//  Created by Khanh Le Do on 12/4/14.
//  Copyright (c) 2014 XeBuyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XBSpriteNodeLoader_CircleBodySource <NSObject>

@optional
- (CGFloat) bodyRadiusForNode:(SKNode*)node;

@end



// Default one. Use this one to avoid hassle to create a standard one.
extern id<XBSpriteNodeLoader_CircleBodySource> XBSpriteNodeLoader_CircleBodySource_Default;
