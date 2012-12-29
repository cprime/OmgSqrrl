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

@class Player;

@interface Squirrel : OmegaObject

@property (nonatomic, retain) Player *player;

- (void)run;
- (void)jump;

@end
