//
//  squirrel.h
//  OmegaSquirrelHackathon
//
//  Created by Patrick Butkiewicz on 12/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

static const float PTM_RATIO = 32.0f; // Pixel-to-Meter Ratio. Convert between Box2D units (meters) and Cocos2D units (points)
static const float MINIMUM_X_VELOCITY = 5.0f;
static const float MAXIMUM_X_VELOCITY = 25.0f;

static const float MINIMUM_Y_VELOCITY = 5.0f;
static const float MAXIMUM_Y_VELOCITY = 25.0f;

static const float JUMP_X_FORCE = 40.0f;
static const float JUMP_Y_FORCE = 220.0f;

typedef enum{
  OSStateFalling,
  OSStateRunning,
  OSStateSingleJump,
  OSStateDoubleJump,
  OSStateDead
}squirrelState;

@interface squirrel : CCSprite {
  b2World *_world;
  b2Body *_body;
}

@property (readonly) BOOL awake;
@property (assign) squirrelState state;

-(void)wake;
-(void)jump;
-(void)limitVelocity;

// init
- (id)initWithWorld:(b2World *)world;
- (void)update;

@end
