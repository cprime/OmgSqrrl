//
//  KillZone.m
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/29/12.
//
//

#import "KillZone.h"

@implementation KillZone

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location {
    return [self initWithWorld:world atLocation:location size:CGSizeMake([[CCDirector sharedDirector] winSize].width, 2)];
}

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location size:(CGSize)size {
    self = [super init];
    if(self) {
        self.world = world;
        self.ethereal = YES;
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"omega_powerline.png"]];
        self.opacity = 0;
        self.contentSize = size;
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
    
    b2PolygonShape shape;
    shape.SetAsBox((self.boundingBox.size.width * .5) / PTM_RATIO, (self.boundingBox.size.height * .5) / PTM_RATIO);
    
    b2FixtureDef fd;
    fd.shape = &shape;
    fd.density = 1.0f;
    fd.restitution = 0.0f;
    fd.friction = 0.0f;
    
    _body->CreateFixture(&fd);
}

@end
