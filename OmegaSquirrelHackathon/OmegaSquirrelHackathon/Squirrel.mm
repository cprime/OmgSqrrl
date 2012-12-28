//
//  Squirrel.m
//  OmegaSquirrelHackathon
//
//  Created by Patrick Butkiewicz on 12/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Squirrel.h"


@implementation Squirrel

@synthesize awake = _awake;
@synthesize state = _state;

- (void)update{
  self.position = ccp(_body->GetPosition().x * PTM_RATIO, _body->GetPosition().y * PTM_RATIO);
  b2Vec2 vel = _body->GetLinearVelocity();
  
  // TODO: Change this to check if squirrel body is colliding with ground or platform object
  if(self.state != SquirrelStateRunning && 1 /* Body is colliding with ground object / platform */){
    NSLog(@"Squirrel Is Running");
    [self setState:SquirrelStateRunning];
  }
  
  float angle = ccpToAngle(ccp(vel.x, vel.y));
  if(_awake){
    self.rotation = -1 * CC_RADIANS_TO_DEGREES(angle);
  }
}

- (void)setupBox2DBody{
  float radius = 16.0f;
  CGSize size = [[CCDirector sharedDirector] winSize];
  float screenHeight = size.height;
  
  CGPoint startPosition = ccp(0, screenHeight/(2+radius));
  
  b2BodyDef bd;
  bd.type = b2_dynamicBody;
  bd.linearDamping = 0.0f;    // Does not slow down over time
  bd.fixedRotation = true;    // Squirrel doesn't rotate at all during the game
  bd.position.Set(startPosition.x/PTM_RATIO, startPosition.y/PTM_RATIO);
  _body = _world->CreateBody(&bd);
  
  b2CircleShape shape;
  shape.m_radius = radius/PTM_RATIO;
  
  b2FixtureDef fd;
  fd.shape = &shape;
  fd.density = 1.0f; 
  fd.restitution = 0.0f;      // 0.0 => Squirrel doesn't bounce when hitting the ground
  fd.friction = 0.0f;         // Lower values = more 'slippery'
  
  _body->CreateFixture(&fd);
  
}

- (void)setupCocos2dChildern {
    CCSprite *sprite = [CCSprite spriteWithFile:@"Icon-72.png"];
    sprite.anchorPoint = ccp(0, 0);
    [self addChild:sprite];
    
    self.contentSize = sprite.contentSize;
}


// Applies a linear "impulse" to get the squirrel moving
-(void)wake{
  _awake = YES;
  _body->SetActive(true);
  _body->ApplyLinearImpulse(b2Vec2(1,1), _body->GetPosition());
}


// Controls the jumping of the squirrel
-(void)jump{
  
  if(self.state == SquirrelStateRunning){
    NSLog(@"Single Jump!");
    _body->ApplyForce(b2Vec2(JUMP_X_FORCE, JUMP_Y_FORCE), _body->GetPosition());
    [self setState:SquirrelStateSingleJump];
  }else if(self.state == SquirrelStateSingleJump){
    NSLog(@"Double Jump!");
    _body->ApplyForce(b2Vec2(JUMP_X_FORCE, JUMP_Y_FORCE), _body->GetPosition());
    [self setState:SquirrelStateDoubleJump];
  }
}


// Sets the limitations for X and Y Velocity
-(void)limitVelocity{
  if (!_awake) return;
  
  b2Vec2 velocity = _body->GetLinearVelocity();
  
  // Check minimum X Velocity
  if(velocity.x < MINIMUM_X_VELOCITY){
    velocity.x = MINIMUM_X_VELOCITY;
  }
  
  // Check minimum Y Velocity
  if(velocity.y < MINIMUM_Y_VELOCITY){
    velocity.y = MINIMUM_Y_VELOCITY;
  }
  
  _body->SetLinearVelocity(velocity);
}

@end
