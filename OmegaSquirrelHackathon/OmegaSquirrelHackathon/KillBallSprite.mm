//
//  KillBallSprite.m
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/29/12.
//
//

#import "KillBallSprite.h"

@implementation KillBallSprite

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location {
    return [self initWithWorld:world atLocation:location size:CGSizeMake(100, 100)];
}

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location size:(CGSize)size {
    self = [super init];
    if(self) {
        self.world = world;
        self.ethereal = NO;
        self.hasCausedDamage = NO;
        self.damage = 20;
        
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"omega_shock.png"]];
        self.scaleX = size.width / self.textureRect.size.width;
        self.scaleY = size.height / self.textureRect.size.height;
        self.color = ccc3(255, 50, 0);
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
    
    b2CircleShape shape;
    shape.m_radius = (self.boundingBox.size.width * .5) / PTM_RATIO;
    
    b2FixtureDef fd;
    fd.shape = &shape;
    fd.density = 1.0f;
    fd.restitution = 1.0f;
    fd.friction = 0.0f;
    
    _body->CreateFixture(&fd);
}

@end
