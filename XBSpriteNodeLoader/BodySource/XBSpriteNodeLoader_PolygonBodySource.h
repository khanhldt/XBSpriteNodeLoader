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
- (CGPathRef) transferPolygonPathForIPhone4xRetinaInPortraitForNode:(SKSpriteNode*)node;
- (CGPathRef) transferPolygonPathForIPhone5xRetinaInPortraitForNode:(SKSpriteNode*)node;
- (CGPathRef) transferPolygonPathForIPadNoretinaInPortraitForNode:(SKSpriteNode*)node;
- (CGPathRef) transferPolygonPathForIPadRetinaInPortraitForNode:(SKSpriteNode*)node;

// Revert to portrait if landscape not found.
- (CGPathRef) transferPolygonPathForIPhone4xRetinaInLandscapeForNode:(SKSpriteNode*)node;
- (CGPathRef) transferPolygonPathForIPhone5xRetinaInLandscapeForNode:(SKSpriteNode*)node;
- (CGPathRef) transferPolygonPathForIPadNoretinaInLandscapeForNode:(SKSpriteNode*)node;
- (CGPathRef) transferPolygonPathForIPadRetinaInLandscapeForNode:(SKSpriteNode*)node;

@end
