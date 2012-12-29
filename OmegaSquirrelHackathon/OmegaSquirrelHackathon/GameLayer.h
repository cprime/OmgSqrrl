//
//  GameLayer.h
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/27/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#include "MyContactListener.h"
#import "GLES-Render.h"
#import "SquirrelSprite.h"

@class GameHUDLayer;
@class Player;
@class LevelTracker;

// GameLayer
@interface GameLayer : CCLayerColor<B2ContactListener>
{
    int _offsetX;
	b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref
    
    SquirrelSprite * _squirrel;
    
    BOOL _tapDown;
}

@property (nonatomic, strong) GameHUDLayer *HUDLayer;
@property (nonatomic, strong) Player *playerModel;
@property (nonatomic, strong) LevelTracker *levelTracker;

@property (retain) CCSpriteBatchNode *batchNode;

// returns a CCScene that contains the GameLayer as the only child
+ (CCScene *)scene;
- (void)setOffsetX:(float)newOffsetX;

@end
