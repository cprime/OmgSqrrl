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
#import "OmegaSprite.h"

#define SquirrelRunImpulse 8
#define SquirrelJumpImpulse 120

@class Player;

@interface SquirrelSprite : OmegaSprite

@property (nonatomic, retain) Player *player;
@property (nonatomic, assign) BOOL hasDoubleJumped;
@property (nonatomic, assign) BOOL hasRestarted;

@property (nonatomic, assign) b2Fixture *feet;
@property (nonatomic, assign) int feetContactCount;

- (void)run;
- (void)jump;

@end
