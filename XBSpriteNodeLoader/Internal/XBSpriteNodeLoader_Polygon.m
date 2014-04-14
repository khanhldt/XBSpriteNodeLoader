//
//  XBSpriteNodeLoader_Polygon.m
//  XBSpriteNodeLoader
//
//  Created by Khanh Le Do on 5/3/14.
//  Copyright (c) 2014 XeBuyt. All rights reserved.
//

#import "XBSpriteNodeLoader_Polygon.h"

#import "XBSpriteNodeLoaderProtected.h"

@interface XBSpriteNodeLoader_Polygon()

@property (nonatomic, strong) id<XBSpriteNodeLoader_PolygonBodySource> delegate;

@end

@implementation XBSpriteNodeLoader_Polygon {
    CGPathRef _path;
    NSLock *_pathLoadLock;
    CGPoint _anchorPoint;
}

#pragma mark Constructors

- (id) initWithTextureName:(NSString *)textureName andAtlasName:(NSString *)atlasName andBodySource:(id<XBSpriteNodeLoader_PolygonBodySource>)delegate {
    if (self = [super initWithTextureName:textureName andAtlasName:atlasName]) {
        self.delegate = delegate;
        _pathLoadLock = [[NSLock alloc] init];
        _anchorPoint = CGPointMake(0.5, 0.5);
    }
    return self;
}

#pragma mark Overriden Methods

- (void) configureBodyPhysicsForNode:(SKSpriteNode*)node {
    
    XBLogMethod();
    
    // Skip if it doesn't have a physics body delegate
    if (self.delegate == nil) {
        return;
    }
    
    if (_path == NULL) {
            
        // Lock to create
        [_pathLoadLock lock];
        
        // Double check before creation of path
        while (_path == NULL) {
            
            // Gather current info
            UIUserInterfaceIdiom idiom = [[UIDevice currentDevice] userInterfaceIdiom];
            UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
            BOOL is4Inches = (fabsf([UIScreen mainScreen].bounds.size.height - 568.0) < 0.01);
            XBLog_Debug(@"Configure Body Physics", @"idiom: %@ - orientation: %@ - is 4 inches: %@", (idiom==UIUserInterfaceIdiomPhone)?@"iPhone":@"iPad", (UIDeviceOrientationIsPortrait(orientation)==YES)?@"Portrait":@"Landscape", is4Inches?@"YES":@"NO");
            
            // Get the CGPath
            if (idiom == UIUserInterfaceIdiomPhone) {
                // iphone
                if (is4Inches) {
                    if (UIDeviceOrientationIsLandscape(orientation)) {
                        if ([self.delegate respondsToSelector:@selector(transferPolygonPathForIPhone4xRetinaInLandscapeForNode:)]) {
                            _path = [self.delegate transferPolygonPathForIPhone4xRetinaInLandscapeForNode:node];
                            break;
                        }
                    }
                    if ([self.delegate respondsToSelector:@selector(transferPolygonPathForIPhone4xRetinaInPortraitForNode:)]) {
                        _path = [self.delegate transferPolygonPathForIPhone4xRetinaInPortraitForNode:node];
                    }
                }
                else {
                    if (UIDeviceOrientationIsLandscape(orientation)) {
                        if ([self.delegate respondsToSelector:@selector(transferPolygonPathForIPhone5xRetinaInLandscapeForNode:)]) {
                            _path = [self.delegate transferPolygonPathForIPhone5xRetinaInLandscapeForNode:node];
                            break;
                        }
                    }
                    if ([self.delegate respondsToSelector:@selector(transferPolygonPathForIPhone5xRetinaInPortraitForNode:)]) {
                        _path = [self.delegate transferPolygonPathForIPhone5xRetinaInPortraitForNode:node];
                    }
                }
            }
            else {
                // ipad
                BOOL isRetina = (fabs([[UIScreen mainScreen] scale] - 2.0) < 0.01);
                if (isRetina == YES) {
                    if (UIDeviceOrientationIsLandscape(orientation)) {
                        if ([self.delegate respondsToSelector:@selector(transferPolygonPathForIPadRetinaInLandscapeForNode:)]) {
                            _path = [self.delegate transferPolygonPathForIPadRetinaInLandscapeForNode:node];
                            break;
                        }
                    }
                    if ([self.delegate respondsToSelector:@selector(transferPolygonPathForIPadRetinaInPortraitForNode:)]) {
                        _path = [self.delegate transferPolygonPathForIPadRetinaInPortraitForNode:node];
                    }
                }
                else {
                    if (UIDeviceOrientationIsLandscape(orientation)) {
                        if ([self.delegate respondsToSelector:@selector(transferPolygonPathForIPadNoretinaInLandscapeForNode:)]) {
                            _path = [self.delegate transferPolygonPathForIPadNoretinaInLandscapeForNode:node];
                            break;
                        }
                    }
                    if ([self.delegate respondsToSelector:@selector(transferPolygonPathForIPadNoretinaInPortraitForNode:)]) {
                        _path = [self.delegate transferPolygonPathForIPadNoretinaInPortraitForNode:node];
                    }
                }
            }
        }
        
        // Unlock
        [_pathLoadLock unlock];
    }
    
    node.anchorPoint = _anchorPoint;
    if (_path) {
        node.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:_path];
    } else {
        node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.frame.size];
    }
}

- (void) cleanUp {
    
    XBLogMethod();
    
    CGPathRelease(_path);
    _path = NULL;
}

@end
