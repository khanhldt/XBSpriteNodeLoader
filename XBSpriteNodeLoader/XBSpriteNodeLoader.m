//
//  XBSpriteNodeLoader.m
//  XBSpriteNodeLoader
//
//  Created by Khanh Le Do on 5/3/14.
//  Copyright (c) 2014 XeBuyt. All rights reserved.
//

#import "XBSpriteNodeLoader.h"
#import "XBSpriteNodeLoaderProtected.h"

#import "XBSpriteNodeLoader_Rectangle.h"
#import "XBSpriteNodeLoader_Polygon.h"
#import "XBSpriteNodeLoader_Circle.h"

id<XBSpriteNodeLoader_CircleBodySource> XBSpriteNodeLoader_CircleBodySource_Default;
id<XBSpriteNodeLoader_RectangleBodySource> XBSpriteNodeLoader_RectangleBodySource_Default;

@implementation XBSpriteNodeLoader {
    NSString *_textureName;
    NSString *_atlasName;
}

static int _sNumberOfCachedAtlas;
static NSMutableArray *_sCachedAtlastNames;
static NSMutableDictionary *_sCachedAtlases;

#pragma mark Constructors

- (id) initWithTextureName:(NSString*)textureName andAtlasName:(NSString*)atlasName {
    if (self = [super init]) {
        _textureName = textureName;
        _atlasName = atlasName;
    }
    return self;
}

#pragma mark Static Methods

// Synchronized method from NSObject to allow initialization of static vars.
// However, this method can still be called by the sub-classes.
+ (void) initialize {
    
    XBLogMethod();
    
    if ([self class] == [XBSpriteNodeLoader class]) {
        _sNumberOfCachedAtlas = 1;
        _sCachedAtlastNames = [NSMutableArray array];
        _sCachedAtlases = [NSMutableDictionary dictionary];
        
        // An empty object to make default circle and rectangle body sources.
        NSObject *defaultObject = [[NSObject alloc] init];
        XBSpriteNodeLoader_CircleBodySource_Default = (id<XBSpriteNodeLoader_CircleBodySource>)defaultObject;
        XBSpriteNodeLoader_RectangleBodySource_Default= (id<XBSpriteNodeLoader_RectangleBodySource>)defaultObject;
    }
}

+ (void) setMaxNumberOfCachedAtlas:(int)numberOfCachedAtlas {
    
    XBLogMethod();
    if (numberOfCachedAtlas <= 0) {
        [NSException raise:@"XBSpriteNodeLoader Error" format:@"Setting a non-positive value to the number of cached atlases."];
        return;
    }
    
    _sNumberOfCachedAtlas = numberOfCachedAtlas;
    [[self class] cleanUp];
}

#pragma mark Factory Methods

+ (XBSpriteNodeLoader*) createRectangleSpriteNodeLoaderFromAtlas:(NSString*)atlasName withTexture:(NSString*)textureName bodySource:(id<XBSpriteNodeLoader_RectangleBodySource>)delegate {
    
    atlasName = [self _makeFinalAtlasName:atlasName];
    [self _loadOrCreateAtlasForKey:atlasName];
    return [[XBSpriteNodeLoader_Rectangle alloc] initWithTextureName:textureName andAtlasName:atlasName andBodySource:delegate];
}

+ (XBSpriteNodeLoader*) createCircleSpriteNodeLoaderFromAtlas:(NSString*)atlasName withTexture:(NSString*)textureName bodySource:(id<XBSpriteNodeLoader_CircleBodySource>)delegate {
    
    atlasName = [self _makeFinalAtlasName:atlasName];
    [self _loadOrCreateAtlasForKey:atlasName];
    return [[XBSpriteNodeLoader_Circle alloc] initWithTextureName:textureName andAtlasName:atlasName andBodySource:delegate];
}

+ (XBSpriteNodeLoader*) createPolygonSpriteNodeLoaderFromAtlas:(NSString*)atlasName withTexture:(NSString*)textureName bodySource:(id<XBSpriteNodeLoader_PolygonBodySource>)delegate {
    
    atlasName = [self _makeFinalAtlasName:atlasName];
    [self _loadOrCreateAtlasForKey:atlasName];
    return [[XBSpriteNodeLoader_Polygon alloc] initWithTextureName:textureName andAtlasName:atlasName andBodySource:delegate];
}

+ (XBSpriteNodeLoader*) createEllipseSpriteNodeLoaderFromAtlas:(NSString*)atlasName withTexture:(NSString*)textureName bodySource:(id<XBSpriteNodeLoader_PolygonBodySource>)delegate {
    
    atlasName = [self _makeFinalAtlasName:atlasName];
    [self _loadOrCreateAtlasForKey:atlasName];
    return [[XBSpriteNodeLoader_Polygon alloc] initWithTextureName:textureName andAtlasName:atlasName andBodySource:delegate];
    
}

+ (void) cleanUp {

    [_sCachedAtlastNames removeAllObjects];
    [_sCachedAtlases removeAllObjects];
}

#pragma mark Private Methods

+ (NSString*) _makeFinalAtlasName:(NSString*)atlasName {
    
    static NSString *ATLAST_POSFIX = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (ATLAST_POSFIX == nil) {
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
                ATLAST_POSFIX = @"";    // No appendix
            }
            else {
                // iPad, check if using retina or not.
                if (fabs([UIScreen mainScreen].scale - 2.0) < 0.001) {
                    ATLAST_POSFIX = @"-ipad@2x";
                } else {
                    ATLAST_POSFIX = @"-ipad";
                }
            }
        }
    });
    return [NSString stringWithFormat:@"%@%@", atlasName, ATLAST_POSFIX];
}

+ (SKTextureAtlas*) _loadOrCreateAtlasForKey:(NSString*)atlasName {
    
    XBLogMethod();
    if (atlasName == nil) {
        return nil;
    }
    
    SKTextureAtlas *atlas = [_sCachedAtlases objectForKey:atlasName];
    if (atlas == nil) {
        XBLog_Debug(@"Load Atlas", @"Atlas not found for key %@. To create one and add.", atlasName);
        atlas = [SKTextureAtlas atlasNamed:atlasName];
        if ([_sCachedAtlases count] == _sNumberOfCachedAtlas) {
            // Full, need to remove the last used element (which is at the end of the atlas name array)
            NSString *lastAtlas = [_sCachedAtlastNames lastObject];
            [_sCachedAtlases removeObjectForKey:lastAtlas];
            [_sCachedAtlastNames removeObject:lastAtlas];
        }
        
        // Add to the dictionary and to the beginning of the usage order array
        [_sCachedAtlases setObject:atlas forKey:atlasName];
        [_sCachedAtlastNames insertObject:atlasName atIndex:0];
        XBLog_Debug(@"Load Atlas", @"Number of atlas loaded: %d. Number of names remembered: %d", _sCachedAtlases.count, _sCachedAtlastNames.count);
        
        [atlas preloadWithCompletionHandler:^{
            ;
        }];
    }
    else {
        // Since the atlas has been used, we move it to the beginning of the usage order array
        [_sCachedAtlastNames removeObject:atlasName];
        [_sCachedAtlastNames insertObject:atlasName atIndex:0];
        XBLog_Debug(@"Load Atlas", @"Number of atlas loaded: %d. Number of names remembered: %d", _sCachedAtlases.count, _sCachedAtlastNames.count);
    }
    return atlas;
}

#pragma mark Public Methods

- (SKSpriteNode*) createSpriteNodeWithName:(NSString*)name withFrame:(CGRect)frame isScaling:(BOOL)scaling {
    
    XBLogMethod();
    
    SKTexture *texture = nil;
    if (_atlasName) {
        SKTextureAtlas *atlas = [[self class] _loadOrCreateAtlasForKey:_atlasName];
        texture = [atlas textureNamed:_textureName];
    }
    else {
        texture = [SKTexture textureWithImageNamed:_textureName];
    }
    
    XBLog_Debug(@"", @"Texture size: %0.2f - %0.2f", texture.size.width, texture.size.height);
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithTexture:texture];
    if (scaling) {
        node.xScale = frame.size.width / texture.size.width;
        node.yScale = frame.size.height / texture.size.height;
    }
    node.name = name;
    node.position = frame.origin;
    
    // Configure physics body according to the configuration of the node loader.
    [self configureBodyPhysicsForNode:node];
    
    return node;
}

- (void) cleanUp {
    
    XBLogMethod();
    
    // Do nothing
    return;
}

- (void) resetBodySource {
    
    XBLogMethod();
    
    // Not yet implemented.
}

@end
