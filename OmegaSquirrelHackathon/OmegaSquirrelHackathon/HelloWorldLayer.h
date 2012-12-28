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

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
  int _offsetX;
	CCTexture2D *spriteTexture_;	// weak ref
	b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref
  
  CCSpriteBatchNode *_batchNode;
  squirrel * _squirrel;
  
  BOOL _tapDown;
}

@property (retain) CCSpriteBatchNode *batchNode;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(void)setOffsetX:(float)newOffsetX;

@end
