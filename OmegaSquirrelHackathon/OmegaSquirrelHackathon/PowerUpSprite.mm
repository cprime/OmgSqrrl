//
//  PowerUpSprite.m
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/29/12.
//
//

#import "PowerUpSprite.h"
#import "PowerUp.h"

@implementation PowerUpSprite

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location {
    return [self initWithWorld:world atLocation:location powerUp:[PowerUp powerUpWithType:PowerUpTypeHealthBoost]];
}

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location powerUp:(PowerUp *)powerUp {
    self = [super init];
    if(self) {
        self.world = world;
        self.ethereal = YES;
        self.hasPickedUp = NO;
        self.powerUp = powerUp;
        
        switch (self.powerUp.type) {
            case PowerUpTypeHealthBoost:
                [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"powerup_life_cherry.png"]];
                break;
            case PowerUpTypeSpeedBoost:
                [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"powerup_jump_butterfly_green.png"]];
                break;
            case PowerUpTypeSuperJump:
                [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"powerup_superjump_butterfly_purple.png"]];
                break;
        }
        
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
