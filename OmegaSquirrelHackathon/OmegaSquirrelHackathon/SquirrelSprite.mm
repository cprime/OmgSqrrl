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

#define SquirrelRunImpulse 40
#define SquirrelJumpImpulse 80

@implementation SquirrelSprite

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location {
    self = [super init];
    if(self) {
        self.world = world;
        self.ethereal = NO;
        
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
    
    b2PolygonShape shape;
    shape.SetAsBox((self.boundingBox.size.width * .5) / PTM_RATIO, (self.boundingBox.size.height * .5) / PTM_RATIO);
    
    b2FixtureDef fd;
    fd.shape = &shape;
    fd.density = 1.0f;
    fd.restitution = 0.0f;      // 0.0 => Squirrel doesn't bounce when hitting the ground
    fd.friction = 0.0f;         // Lower values = more 'slippery'
    
    _body->CreateFixture(&fd);
}

// Applies a linear "impulse" to get the squirrel moving
- (void)run {
    _body->SetLinearVelocity(b2Vec2(0, _body->GetLinearVelocity().y));
    _body->ApplyLinearImpulse(b2Vec2(SquirrelRunImpulse * self.player.currentRunSpeed, 0), _body->GetPosition());
}


// Controls the jumping of the squirrel
-(void)jump {
    _body->SetLinearVelocity(b2Vec2(_body->GetLinearVelocity().x, 0));
    _body->ApplyLinearImpulse(b2Vec2(0, SquirrelJumpImpulse * self.player.currentJumpPower), _body->GetPosition());
}

@end
