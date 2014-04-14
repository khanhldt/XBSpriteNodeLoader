//
//  XBSpriteNodeLoader_Polygon.h
//  XBSpriteNodeLoader
//
//  Created by Khanh Le Do on 5/3/14.
//  Copyright (c) 2014 XeBuyt. All rights reserved.
//

#import "XBSpriteNodeLoader.h"
#import "XBSpriteNodeLoader_PolygonBodySource.h"

@interface XBSpriteNodeLoader_Polygon : XBSpriteNodeLoader

- (id) initWithTextureName:(NSString*)textureName andAtlasName:(NSString*)atlasName andBodySource:(id<XBSpriteNodeLoader_PolygonBodySource>)delegate;

@end
