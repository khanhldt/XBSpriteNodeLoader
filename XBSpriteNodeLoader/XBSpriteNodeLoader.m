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

#pragma mark Configurations

static NSMutableArray *_sCachedAtlastNames;
static NSMutableDictionary *_sCachedAtlases;
static int _sNumberOfCachedAtlas;

static NSString * _sAtlasSuffix_iPhoneRetina = @"@2x";
static NSString * _sAtlasSuffix_iPadNonRetina = @"~ipad";
static NSString * _sAtlasSuffix_iPadRetina = @"~ipad@2x";

static NSString * _sTextureSuffix_iPhoneRetina = @"@2x";
static NSString * _sTextureSuffix_iPadNonRetina = @"~ipad";
static NSString * _sTextureSuffix_iPadRetina = @"~ipad@2x";

static NSString * __strong * _sCurrentAtlasSuffix = nil;
static NSString * __strong *_sCurrentTextureSuffix = nil;
static BOOL _sIsRetina = NO;

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
        
        // Detect current device and retina config
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            // iPad, check if using retina or not.
            if (fabs([UIScreen mainScreen].scale - 2.0) < 0.001) {
                _sCurrentAtlasSuffix = &_sAtlasSuffix_iPadRetina;
                _sCurrentTextureSuffix = &_sTextureSuffix_iPadRetina;
                _sIsRetina = YES;
            } else {
                _sCurrentAtlasSuffix = &_sAtlasSuffix_iPadNonRetina;
                _sCurrentTextureSuffix = &_sTextureSuffix_iPadNonRetina;
                _sIsRetina = NO;
            }
        }
        else {
            // iPhone, only iPhone retina is supported.
            _sCurrentAtlasSuffix = &_sAtlasSuffix_iPhoneRetina;
            _sCurrentTextureSuffix = &_sTextureSuffix_iPhoneRetina;
            _sIsRetina = YES;
        }
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


+ (void) setAtlasSuffix:(NSString*)suffix forDevice:(UIUserInterfaceIdiom)device withRetinaDisplay:(BOOL)isRetinaDisplay {
    
    switch (device) {
        case UIUserInterfaceIdiomPad: {
            if (isRetinaDisplay) {
                _sAtlasSuffix_iPadRetina = suffix;
            }
            else {
                _sAtlasSuffix_iPadNonRetina = suffix;
            }
            break;
        }
        case UIUserInterfaceIdiomPhone: {
            if (isRetinaDisplay) {
                _sAtlasSuffix_iPhoneRetina = suffix;
            }
            break;
        }
        default:
            break;
    }
}

+ (void) setTextureSuffix:(NSString*)suffix forDevice:(UIUserInterfaceIdiom)device withRetinaDisplay:(BOOL)isRetinaDisplay {
    
    switch (device) {
        case UIUserInterfaceIdiomPad: {
            if (isRetinaDisplay) {
                _sTextureSuffix_iPadRetina = suffix;
            }
            else {
                _sTextureSuffix_iPadNonRetina = suffix;
            }
            break;
        }
        case UIUserInterfaceIdiomPhone: {
            if (isRetinaDisplay) {
                _sTextureSuffix_iPhoneRetina = suffix;
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark Factory Methods

+ (XBSpriteNodeLoader*) createRectangleSpriteNodeLoaderFromAtlas:(NSString*)atlasName withTexture:(NSString*)textureName bodySource:(id<XBSpriteNodeLoader_RectangleBodySource>)delegate {
    
    [self _preprocessAtlasName:&atlasName andTextureName:&textureName];
    return [[XBSpriteNodeLoader_Rectangle alloc] initWithTextureName:textureName andAtlasName:atlasName andBodySource:delegate];
}

+ (XBSpriteNodeLoader*) createCircleSpriteNodeLoaderFromAtlas:(NSString*)atlasName withTexture:(NSString*)textureName bodySource:(id<XBSpriteNodeLoader_CircleBodySource>)delegate {
    
    [self _preprocessAtlasName:&atlasName andTextureName:&textureName];
    return [[XBSpriteNodeLoader_Circle alloc] initWithTextureName:textureName andAtlasName:atlasName andBodySource:delegate];
}

+ (XBSpriteNodeLoader*) createPolygonSpriteNodeLoaderFromAtlas:(NSString*)atlasName withTexture:(NSString*)textureName bodySource:(id<XBSpriteNodeLoader_PolygonBodySource>)delegate {
    
    [self _preprocessAtlasName:&atlasName andTextureName:&textureName];
    return [[XBSpriteNodeLoader_Polygon alloc] initWithTextureName:textureName andAtlasName:atlasName andBodySource:delegate];
}

+ (XBSpriteNodeLoader*) createEllipseSpriteNodeLoaderFromAtlas:(NSString*)atlasName withTexture:(NSString*)textureName bodySource:(id<XBSpriteNodeLoader_PolygonBodySource>)delegate {
    
    [self _preprocessAtlasName:&atlasName andTextureName:&textureName];
    return [[XBSpriteNodeLoader_Polygon alloc] initWithTextureName:textureName andAtlasName:atlasName andBodySource:delegate];
}

+ (void) cleanUp {

    [_sCachedAtlastNames removeAllObjects];
    [_sCachedAtlases removeAllObjects];
}

#pragma mark Private Methods

+ (void) _preprocessAtlasName:(NSString**)atlasNamePointer andTextureName:(NSString**)textureNamePointer {
    
    *atlasNamePointer = [NSString stringWithFormat:@"%@%@", *atlasNamePointer, *_sCurrentAtlasSuffix];
    *textureNamePointer = [NSString stringWithFormat:@"%@%@", *textureNamePointer, *_sCurrentTextureSuffix];
    [self _loadOrCreateAtlasForKey:*atlasNamePointer];
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
        // Only scale if really needed to
        if (fabs(frame.size.width - texture.size.width) > 0.001) {
            node.xScale = frame.size.width / texture.size.width;
        }
        if (fabs(frame.size.height - texture.size.height) > 0.001) {
            node.yScale = frame.size.height / texture.size.height;
        }
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
