//
//  XBSpriteNodeLoader_Rectangle.h
//  XBSpriteNodeLoader
//
//  Created by Khanh Le Do on 5/3/14.
//  Copyright (c) 2014 XeBuyt. All rights reserved.
//

#import "XBSpriteNodeLoader.h"
#import "XBSpriteNodeLoader_RectangleBodySource.h"

@interface XBSpriteNodeLoader_Rectangle : XBSpriteNodeLoader

- (id) initWithTextureName:(NSString*)textureName andAtlasName:(NSString*)atlasName andBodySource:(id<XBSpriteNodeLoader_RectangleBodySource>)delegate;

@end
