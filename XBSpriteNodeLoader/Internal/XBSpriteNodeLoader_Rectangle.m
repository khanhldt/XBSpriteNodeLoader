//
//  XBSpriteNodeLoader_Rectangle.m
//  XBSpriteNodeLoader
//
//  Created by Khanh Le Do on 5/3/14.
//  Copyright (c) 2014 XeBuyt. All rights reserved.
//

#import "XBSpriteNodeLoader_Rectangle.h"
#import "XBSpriteNodeLoaderProtected.h"

@interface XBSpriteNodeLoader_Rectangle ()

@property (nonatomic, strong) id<XBSpriteNodeLoader_RectangleBodySource> delegate;

@end

@implementation XBSpriteNodeLoader_Rectangle

#pragma mark Constructors

- (id) initWithTextureName:(NSString*)textureName andAtlasName:(NSString*)atlasName andBodySource:(id<XBSpriteNodeLoader_RectangleBodySource>)delegate {
    if (self = [super initWithTextureName:textureName andAtlasName:atlasName]) {
        self.delegate = delegate;
        // BUG: Should verify the requirements of the delegate right away here
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
    
    // Get body size
    CGSize frameSize = node.frame.size;
    if ([self.delegate respondsToSelector:@selector(bodySize:forNode:)]) {
        BOOL isRelative = true;
        frameSize = [self.delegate bodySize:&isRelative forNode:node];
        if (isRelative) {
            frameSize.width = frameSize.width * node.size.width;
            frameSize.height = frameSize.height * node.size.height;
        }
    }
    
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:frameSize];
}

- (void) cleanUp {
    XBLogMethod();
    // Nothing special to clean up.
}

@end
