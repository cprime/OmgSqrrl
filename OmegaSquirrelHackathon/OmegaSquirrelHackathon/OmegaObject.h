//
//  OmegaObject.h
//  OmegaSquirrelHackathon
//
//  Created by Patrick Butkiewicz on 12/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

@interface OmegaObject : CCNode {
    b2World *_world;
    b2Body *_body;
}

@property (nonatomic, assign) b2World *world;
@property (nonatomic, assign) b2Body *body;

- (id)initWithWorld:(b2World *)world;

- (void)setupBox2DBody;
- (void)setupCocos2dChildern;

@end
