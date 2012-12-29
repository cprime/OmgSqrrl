//
//  PowerPole.m
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/29/12.
//
//

#import "PowerPole.h"

@implementation PowerPole

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location {
    self = [super init];
    if(self) {
        self.world = world;
        self.ethereal = NO;
        
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"omega_telephonepole.png"]];
        
        [self setupBox2DBodyAtLocation:location];
    }
    return self;
}

- (void)setupBox2DBodyAtLocation:(CGPoint)location {
    b2BodyDef bd;
    bd.type = b2_staticBody;
    bd.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
    bd.userData = self;
    _body = _world->CreateBody(&bd);
    
    b2EdgeShape shape;
    
    b2FixtureDef fd;
    fd.shape = &shape;
    fd.density = 1.0f;
    fd.restitution = 0.0f;
    fd.friction = 0.0f;
    
    //row 1, col 1
    int num = 19;
    b2Vec2 verts[] = {
        b2Vec2(-15.7f / PTM_RATIO, -127.9f / PTM_RATIO),
        b2Vec2(-23.2f / PTM_RATIO, 54.1f / PTM_RATIO),
        b2Vec2(-58.2f / PTM_RATIO, 53.1f / PTM_RATIO),
        b2Vec2(-65.2f / PTM_RATIO, 88.6f / PTM_RATIO),
        b2Vec2(-64.7f / PTM_RATIO, 103.6f / PTM_RATIO),
        b2Vec2(-13.2f / PTM_RATIO, 107.6f / PTM_RATIO),
        b2Vec2(-13.2f / PTM_RATIO, 126.6f / PTM_RATIO),
        b2Vec2(12.8f / PTM_RATIO, 129.1f / PTM_RATIO),
        b2Vec2(15.3f / PTM_RATIO, 127.6f / PTM_RATIO),
        b2Vec2(14.8f / PTM_RATIO, 108.6f / PTM_RATIO),
        b2Vec2(65.3f / PTM_RATIO, 111.1f / PTM_RATIO),
        b2Vec2(65.3f / PTM_RATIO, 66.6f / PTM_RATIO),
        b2Vec2(17.3f / PTM_RATIO, 59.6f / PTM_RATIO),
        b2Vec2(16.3f / PTM_RATIO, 40.1f / PTM_RATIO),
        b2Vec2(51.8f / PTM_RATIO, 39.1f / PTM_RATIO),
        b2Vec2(52.3f / PTM_RATIO, -7.4f / PTM_RATIO),
        b2Vec2(14.8f / PTM_RATIO, -8.9f / PTM_RATIO),
        b2Vec2(20.8f / PTM_RATIO, -128.4f / PTM_RATIO),
        b2Vec2(-15.2f / PTM_RATIO, -127.9f / PTM_RATIO)
    };
    for(int i = 0; i < num - 1; i++) {
        b2Vec2 left = verts[i];
        b2Vec2 right = verts[i+1];
        shape.Set(left, right);
        _body->CreateFixture(&fd);
    }
}

@end
