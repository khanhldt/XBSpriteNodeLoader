//
//  XBSpriteNodeLoader+XBSpriteNodeLoaderInternal.h
//  XBSpriteNodeLoader
//
//  Created by Khanh Le Do on 5/3/14.
//  Copyright (c) 2014 XeBuyt. All rights reserved.
//

#import "XBSpriteNodeLoader.h"

@interface XBSpriteNodeLoader (Protected)

#pragma mark Protected Methods

- (id) initWithTextureName:(NSString*)textureName andAtlasName:(NSString*)atlasName;

#pragma mark Overriden Methods

- (void) configureBodyPhysicsForNode:(SKSpriteNode*)node;

@end
