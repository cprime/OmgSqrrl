//
//  HelloWorldLayer.h
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/27/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "squirrel.h"

@class GameHUDLayer;
@class Player;
@class LevelTracker;

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    int _offsetX;
	CCTexture2D *spriteTexture_;	// weak ref
	b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref
    
    CCSpriteBatchNode *_batchNode;
    Squirrel * _squirrel;
    
    BOOL _tapDown;
}

@property (nonatomic, strong) GameHUDLayer *HUDLayer;
@property (nonatomic, strong) Player *playerModel;
@property (nonatomic, strong) LevelTracker *levelTracker;

@property (retain) CCSpriteBatchNode *batchNode;

// returns a CCScene that contains the HelloWorldLayer as the only child
+ (CCScene *)scene;
- (void)setOffsetX:(float)newOffsetX;

@end
