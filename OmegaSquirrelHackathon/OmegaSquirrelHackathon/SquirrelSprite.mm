//
//  Squirrel.m
//  OmegaSquirrelHackathon
//
//  Created by Patrick Butkiewicz on 12/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SquirrelSprite.h"
#import "Player.h"
#import "PowerUp.h"

#define animationTag 1337

@implementation SquirrelSprite

- (void)setFeetContactCount:(int)feetContactCount {
    int prev = _feetContactCount;
    _feetContactCount = feetContactCount;
    
    if(prev == 0 && feetContactCount > 0) {
        self.hasDoubleJumped = NO;
        
        NSMutableArray *walkAnimFrames = [NSMutableArray array];
        for(int i = 1; i < 5; i++) {
            [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"squirrel-frames_0%d.png", i]]];
        }
        CCAnimation *walkAnim = [CCAnimation animationWithSpriteFrames:walkAnimFrames delay:.1];
        CCRepeatForever *ret = [[[CCRepeatForever alloc] initWithAction:[CCAnimate actionWithAnimation:walkAnim]] autorelease];
        ret.tag = animationTag;
        [self runAction:ret];
    } else if(prev > 0 && feetContactCount == 0) {
        [self stopActionByTag:animationTag];
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"squirrel-frames_03.png"]];
    }

}

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location {
    self = [super init];
    if(self) {
        self.world = world;
        self.ethereal = NO;
        self.feetContactCount = 0;
        self.hasRestarted = 0;
        
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"squirrel-frames_02.png"]];
        
        [self setupBox2DBodyAtLocation:location];
    }
    return self;
}

- (void)setupBox2DBodyAtLocation:(CGPoint)location {
    b2BodyDef bd;
    bd.type = b2_dynamicBody;
    bd.linearDamping = 0.0f;    // Does not slow down over time
    bd.fixedRotation = true;    // Squirrel doesn't rotate at all during the game
    bd.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
    bd.userData = self;
    _body = _world->CreateBody(&bd);
    
    float width = (self.boundingBox.size.width * .5) / PTM_RATIO;
    float height = (self.boundingBox.size.height * .5) / PTM_RATIO;
    
    //bottom
    b2PolygonShape bottomShape;
    bottomShape.SetAsBox(width - 0.2, height, b2Vec2(0, -0.1), 0);
    
    b2FixtureDef bottomFD;
    bottomFD.shape = &bottomShape;
    bottomFD.density = 0.5f;
    bottomFD.friction = 0.0f;
    bottomFD.restitution = 0.0f;
    
    _feet = _body->CreateFixture(&bottomFD);
    
    //top
    b2PolygonShape topShape;
    topShape.SetAsBox(width, height, b2Vec2(0, 0.1), 0);
    
    b2FixtureDef topFD;
    topFD.shape = &topShape;
    topFD.density = 0.5f;
    topFD.friction = 0.0f;
    topFD.restitution = 0.25f;
    
    _body->CreateFixture(&topFD);
}

// Applies a linear "impulse" to get the squirrel moving
- (void)run {
    _body->SetLinearVelocity(b2Vec2(SquirrelRunImpulse * self.player.currentRunSpeed * .2, _body->GetLinearVelocity().y));
//    _body->ApplyLinearImpulse(b2Vec2(SquirrelRunImpulse * self.player.currentRunSpeed, 0), _body->GetPosition());
}


// Controls the jumping of the squirrel
-(void)jump {
    _body->SetLinearVelocity(b2Vec2(_body->GetLinearVelocity().x, 0));
    _body->ApplyLinearImpulse(b2Vec2(0, SquirrelJumpImpulse * self.player.currentJumpPower * 2), _body->GetPosition());
}

@end
