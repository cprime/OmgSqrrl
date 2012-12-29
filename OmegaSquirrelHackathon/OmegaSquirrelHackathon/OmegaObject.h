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

@interface OmegaObject : CCSprite {
    b2World *_world;
    b2Body *_body;
}

@property (nonatomic, assign) b2World *world;
@property (nonatomic, assign) b2Body *body;
@property (nonatomic, assign) BOOL ethereal;

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location;
- (void)setupBox2DBodyAtLocation:(CGPoint)location;

@end
