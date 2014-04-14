//
//  XBSpriteNodeLoader_RectangleBodySource.h
//  XBSpriteNodeLoader
//
//  Created by Khanh Le Do on 12/4/14.
//  Copyright (c) 2014 XeBuyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XBSpriteNodeLoader_RectangleBodySource <NSObject>

@optional
- (CGSize) bodySize:(BOOL*)isRelative forNode:(SKNode*)node;

@end


// Default one. Use this one to avoid hassle to create a standard one.
extern id<XBSpriteNodeLoader_RectangleBodySource> XBSpriteNodeLoader_RectangleBodySource_Default;
