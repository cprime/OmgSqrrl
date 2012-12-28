//
//  Squirrel.h
//  OmegaSquirrelHackathon
//
//  Created by Patrick Butkiewicz on 12/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "OmegaObject.h"

static const float MINIMUM_X_VELOCITY = 5.0f;
static const float MAXIMUM_X_VELOCITY = 25.0f;

static const float MINIMUM_Y_VELOCITY = 5.0f;
static const float MAXIMUM_Y_VELOCITY = 25.0f;

static const float JUMP_X_FORCE = 40.0f;
static const float JUMP_Y_FORCE = 220.0f;

typedef enum{
  SquirrelStateFalling,
  SquirrelStateRunning,
  SquirrelStateSingleJump,
  SquirrelStateDoubleJump,
  SquirrelStateDead
} SquirrelState;

@interface Squirrel : OmegaObject

@property (readonly) BOOL awake;
@property (assign) SquirrelState state;

-(void)wake;
-(void)jump;
-(void)limitVelocity;

- (void)update;

@end
