//
//  OmegaSprite.m
//  OmegaSquirrelHackathon
//
//  Created by Patrick Butkiewicz on 12/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "OmegaSprite.h"

@implementation OmegaSprite

@synthesize world = _world;
@synthesize body = _body;

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location {
    if((self = [super init])){
        _world = world;
        _ethereal = NO;
        [self setupBox2DBodyAtLocation:location];
    }
    
    return self;
}

- (void)setupBox2DBodyAtLocation:(CGPoint)location {
    //should override
}

@end
