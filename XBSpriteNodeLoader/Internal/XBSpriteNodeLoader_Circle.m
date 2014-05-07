//
//  XBSpriteNodeLoader_Circle.m
//  XBSpriteNodeLoader
//
//  Created by Khanh Le Do on 5/3/14.
//  Copyright (c) 2014 XeBuyt. All rights reserved.
//

#import "XBSpriteNodeLoader_Circle.h"
#import "XBSpriteNodeLoaderProtected.h"

@interface XBSpriteNodeLoader_Circle ()

@property (nonatomic, strong) id<XBSpriteNodeLoader_CircleBodySource> delegate;

@end

@implementation XBSpriteNodeLoader_Circle

#pragma mark Constructors

- (id) initWithTextureName:(NSString*)textureName andAtlasName:(NSString*)atlasName andBodySource:(id<XBSpriteNodeLoader_CircleBodySource>)delegate {
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
    CGFloat radius = 0.0;
    node.anchorPoint = CGPointMake(0.5, 0.5);
    if ([self.delegate respondsToSelector:@selector(bodyRadiusForNode:)]) {
        radius = [self.delegate bodyRadiusForNode:node];
    }
    else {
        radius = MAX(node.frame.size.width, node.frame.size.height) / 2;
    }
    
    XBLog_Debug(@"Circle Body", @"Radius is %0.2f", radius);
    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:radius];
}

- (void) cleanUp {
    
    XBLogMethod();
    // Nothing special to clean up.
}

@end
