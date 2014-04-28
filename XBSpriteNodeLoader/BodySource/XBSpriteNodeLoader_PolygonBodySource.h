//
//  XBSpriteNodeLoader_PolygonBodySource.h
//  XBSpriteNodeLoader
//
//  Created by Khanh Le Do on 12/4/14.
//  Copyright (c) 2014 XeBuyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XBSpriteNodeLoader_PolygonBodySource <NSObject>

// If the condition is met but the corresponding callback is not implemented, a rectangular shape that surrounds the frame shall be used.

@optional
- (CGPathRef) createPolygonPathForIPhone4xRetinaInPortraitForNode:(SKSpriteNode*)node;
- (CGPathRef) createPolygonPathForIPhone5xRetinaInPortraitForNode:(SKSpriteNode*)node;
- (CGPathRef) createPolygonPathForIPadNoretinaInPortraitForNode:(SKSpriteNode*)node;
- (CGPathRef) createPolygonPathForIPadRetinaInPortraitForNode:(SKSpriteNode*)node;

// Revert to portrait if landscape not found.
- (CGPathRef) createPolygonPathForIPhone4xRetinaInLandscapeForNode:(SKSpriteNode*)node;
- (CGPathRef) createPolygonPathForIPhone5xRetinaInLandscapeForNode:(SKSpriteNode*)node;
- (CGPathRef) createPolygonPathForIPadNoretinaInLandscapeForNode:(SKSpriteNode*)node;
- (CGPathRef) createPolygonPathForIPadRetinaInLandscapeForNode:(SKSpriteNode*)node;

@end
