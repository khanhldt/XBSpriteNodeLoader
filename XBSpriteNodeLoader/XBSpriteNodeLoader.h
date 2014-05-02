//
//  XBSpriteNodeLoader.h
//  XBSpriteNodeLoader
//
//  Created by Khanh Le Do on 5/3/14.
//  Copyright (c) 2014 XeBuyt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XBSpriteNodeLoader_CircleBodySource.h"
#import "XBSpriteNodeLoader_RectangleBodySource.h"
#import "XBSpriteNodeLoader_PolygonBodySource.h"

@interface XBSpriteNodeLoader : NSObject

#pragma mark Static and Factory Methods

/**
 * Call this method to set up the number of cached atlases to be used throughout the game.
 * IMPORTANT: Should call this method once during an app life cycle, as calling this method shall reset all the current cached atlases.
 */
+ (void) setMaxNumberOfCachedAtlas:(int)numberOfCachedAtlas;

/**
 * Call this method to allow using the same images (with the convention of @2x postfix) for iphone retina and iPad non-retina to reduce the size of the binary if wanting to.
 * By default, this is NOT enabled.
 * By enabling this, the creation of any XBSpriteNodeLoader shall try to add @2x at the end of the textureName if it's not already there.
 */
+ (void) setShareImagesBetweenIphoneRetinaAndIpadNonRetina:(BOOL)sharing;

/**
 * Keep this instance around for loading the same sprite node as it has some cached data that makes the loading faster.
 */
+ (XBSpriteNodeLoader*) createRectangleSpriteNodeLoaderFromAtlas:(NSString*)atlasName withTexture:(NSString*)textureName bodySource:(id<XBSpriteNodeLoader_RectangleBodySource>)delegate;

+ (XBSpriteNodeLoader*) createCircleSpriteNodeLoaderFromAtlas:(NSString*)atlasName withTexture:(NSString*)textureName bodySource:(id<XBSpriteNodeLoader_CircleBodySource>)delegate;

+ (XBSpriteNodeLoader*) createPolygonSpriteNodeLoaderFromAtlas:(NSString*)atlasName withTexture:(NSString*)textureName bodySource:(id<XBSpriteNodeLoader_PolygonBodySource>)delegate;

+ (void) cleanUp;

#pragma mark Public Methods

/**
 * Create node using the configurations of the loader for a given frame.
 */
- (SKSpriteNode*) createSpriteNodeWithName:(NSString*)name withFrame:(CGRect)frame isScaling:(BOOL)scaling;

/**
 * Call this method to clean up when ad shows up or the app simply wants to save memory. All the cached data shall be cleared off and next call will have to restart.
 * However, the configuration data shall not be removed. The object is still usable after this call, only the efficiency shall be reduced.
 */
- (void) cleanUp;

/**
 * Call this method to ask the library to review the body source, which will trigger the delegate to be called again to gather updated info.
 */
#warning Not yet implemented.
- (void) resetBodySource;

@end