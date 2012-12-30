//
//  AcornSprite.m
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/29/12.
//
//

#import "AcornSprite.h"

@implementation AcornSprite

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location {
    return [self initWithWorld:world atLocation:location type:AcornTypeOne];
}

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location type:(AcornType)type {
    self = [super init];
    if(self) {
        self.world = world;
        self.ethereal = YES;
        self.hasPickedUp = NO;
        self.type = type;
        
        switch (self.type) {
            case AcornTypeOne:
                [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"acorn_brown.png"]];
                break;
            case AcornTypeThree:
                [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"acorn_green.png"]];
                break;
            case AcornTypeTen:
                [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"acorn_red.png"]];
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

- (int)value {
    switch (self.type) {
        case AcornTypeOne:
            return 1;
        case AcornTypeThree:
            return 3;
        case AcornTypeTen:
            return 10;
    }
}

@end
