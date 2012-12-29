//
//  LargeHouseSprite.m
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/29/12.
//
//

#import "LargeHouseSprite.h"

@implementation LargeHouseSprite

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location {
    self = [super init];
    if(self) {
        self.world = world;
        self.ethereal = NO;
        
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"omega_black_house_2.png"]];
        
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
    int num = 16;
    b2Vec2 verts[] = {
        b2Vec2(-292.0f / PTM_RATIO, -299.0f / PTM_RATIO),
        b2Vec2(-294.0f / PTM_RATIO, 80.0f / PTM_RATIO),
        b2Vec2(-352.0f / PTM_RATIO, 82.0f / PTM_RATIO),
        b2Vec2(-374.0f / PTM_RATIO, 140.0f / PTM_RATIO),
        b2Vec2(-332.0f / PTM_RATIO, 150.0f / PTM_RATIO),
        b2Vec2(-39.0f / PTM_RATIO, 280.0f / PTM_RATIO),
        b2Vec2(-1.0f / PTM_RATIO, 300.0f / PTM_RATIO),
        b2Vec2(154.0f / PTM_RATIO, 225.0f / PTM_RATIO),
        b2Vec2(156.0f / PTM_RATIO, 271.0f / PTM_RATIO),
        b2Vec2(259.0f / PTM_RATIO, 274.0f / PTM_RATIO),
        b2Vec2(260.0f / PTM_RATIO, 247.0f / PTM_RATIO),
        b2Vec2(260.0f / PTM_RATIO, 182.0f / PTM_RATIO),
        b2Vec2(374.0f / PTM_RATIO, 141.0f / PTM_RATIO),
        b2Vec2(353.0f / PTM_RATIO, 84.0f / PTM_RATIO),
        b2Vec2(297.0f / PTM_RATIO, 79.0f / PTM_RATIO),
        b2Vec2(292.0f / PTM_RATIO, -299.0f / PTM_RATIO)
    };
    for(int i = 0; i < num - 1; i++) {
        b2Vec2 left = verts[i];
        b2Vec2 right = verts[i+1]; 
        shape.Set(left, right);
        _body->CreateFixture(&fd);
    }
}

@end
