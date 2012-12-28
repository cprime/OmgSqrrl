//
//  OmegaObject.m
//  OmegaSquirrelHackathon
//
//  Created by Patrick Butkiewicz on 12/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "OmegaObject.h"

@implementation OmegaObject

@synthesize world = _world;
@synthesize body = _body;

- (id)initWithWorld:(b2World *)world {
    if((self = [super init])){
        _world = world;
        
        [self setupBox2DBody];
        [self setupCocos2dChildern];
    }
    
    return self;
}

- (void)setupBox2DBody {
    //should override
}

- (void)setupCocos2dChildern {
    //should override
}

@end
