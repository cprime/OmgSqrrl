//
//  GamePanel.m
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/29/12.
//
//

#import "GamePanel.h"
#import "OmegaSprite.h"
#import "TelephonePoleSprite.h"
#import "KillZoneSprite.h"
#import "TelephoneLineSprite.h"
#import "LargeHouseSprite.h"
#import "KillBallSprite.h"
#import "PowerUpSprite.h"
#import "PowerUp.h"
#import "AcornSprite.h"

#define BackgroundCount 4
#define BackgroundName [NSString stringWithFormat:@"Omega_ipad_bckgrnd_%d.png", (nextBackground % BackgroundCount) + 1]
static int nextBackground = 3;

#define BackgroundBuffer 50

@implementation GamePanel

- (OmegaSprite *)randomPickupWithWorld:(b2World *)world atOffset:(CGPoint)startingOffset {
    int random = arc4random() % 100;
    if(random < 50) {
        return [[AcornSprite alloc] initWithWorld:world atLocation:startingOffset];
    } else if(random < 70) {
        return [[AcornSprite alloc] initWithWorld:world atLocation:startingOffset type:AcornTypeThree];
    } else if(random < 80) {
        return [[AcornSprite alloc] initWithWorld:world atLocation:startingOffset type:AcornTypeTen];
    } else if(random < 87) {
        return [[PowerUpSprite alloc] initWithWorld:world atLocation:startingOffset powerUp:[PowerUp powerUpWithType:PowerUpTypeHealthBoost]];
    } else if(random < 94) {
        return [[PowerUpSprite alloc] initWithWorld:world atLocation:startingOffset powerUp:[PowerUp powerUpWithType:PowerUpTypeSpeedBoost]];
    } else if(random < 100) {
        return [[PowerUpSprite alloc] initWithWorld:world atLocation:startingOffset powerUp:[PowerUp powerUpWithType:PowerUpTypeSuperJump]];
    }
    return [[AcornSprite alloc] initWithWorld:world atLocation:startingOffset];
}

- (void)setupPanel1WithWorld:(b2World *)world atOffset:(CGPoint)startingOffset {
    OmegaSprite *sprite = [[[TelephoneLineSprite alloc] initWithWorld:world atLocation:ccpAdd(startingOffset, ccp(285, 500))] autorelease];
    [self.sprites addObject:sprite];
    
    sprite = [[[TelephoneLineSprite alloc] initWithWorld:world atLocation:ccpAdd(startingOffset, ccp(700, 200))] autorelease];
    [self.sprites addObject:sprite];
    
    sprite = [self randomPickupWithWorld:world atOffset:ccpAdd(startingOffset, ccp(400, 700))];
    [self.sprites addObject:sprite];
    
    sprite = [self randomPickupWithWorld:world atOffset:ccpAdd(startingOffset, ccp(700, 400))];
    [self.sprites addObject:sprite];
    
    sprite = [self randomPickupWithWorld:world atOffset:ccpAdd(startingOffset, ccp(950, 350))];
    [self.sprites addObject:sprite];
}

- (void)setupPanel2WithWorld:(b2World *)world atOffset:(CGPoint)startingOffset {
    OmegaSprite *sprite = [[[LargeHouseSprite alloc] initWithWorld:world atLocation:ccpAdd(startingOffset, ccp(500, 150))] autorelease];
    [self.sprites addObject:sprite];
    
    sprite = [self randomPickupWithWorld:world atOffset:ccpAdd(startingOffset, ccp(100, 450))];
    [self.sprites addObject:sprite];
    
    sprite = [self randomPickupWithWorld:world atOffset:ccpAdd(startingOffset, ccp(300, 550))];
    [self.sprites addObject:sprite];
    
    sprite = [[[KillBallSprite alloc] initWithWorld:world atLocation:ccpAdd(startingOffset, ccp(650, 450))] autorelease];
    [self.sprites addObject:sprite];
}

- (void)setupPanel3WithWorld:(b2World *)world atOffset:(CGPoint)startingOffset {
    OmegaSprite *sprite = [[[TelephoneLineSprite alloc] initWithWorld:world atLocation:ccpAdd(startingOffset, ccp(285, 50))] autorelease];
    [self.sprites addObject:sprite];
    
    sprite = [[[TelephoneLineSprite alloc] initWithWorld:world atLocation:ccpAdd(startingOffset, ccp(585, 150))] autorelease];
    [self.sprites addObject:sprite];
    
    sprite = [[[TelephoneLineSprite alloc] initWithWorld:world atLocation:ccpAdd(startingOffset, ccp(885, 250))] autorelease];
    [self.sprites addObject:sprite];
    
    sprite = [self randomPickupWithWorld:world atOffset:ccpAdd(startingOffset, ccp(75, 125))];
    [self.sprites addObject:sprite];
    
    sprite = [self randomPickupWithWorld:world atOffset:ccpAdd(startingOffset, ccp(200, 200))];
    [self.sprites addObject:sprite];
    
    sprite = [self randomPickupWithWorld:world atOffset:ccpAdd(startingOffset, ccp(900, 500))];
    [self.sprites addObject:sprite];
    
    sprite = [[[KillBallSprite alloc] initWithWorld:world atLocation:ccpAdd(startingOffset, ccp(450, 200))] autorelease];
    [self.sprites addObject:sprite];
}

- (void)setupPanel4WithWorld:(b2World *)world atOffset:(CGPoint)startingOffset {
    OmegaSprite *sprite = [[[LargeHouseSprite alloc] initWithWorld:world atLocation:ccpAdd(startingOffset, ccp(300, 150))] autorelease];
    [self.sprites addObject:sprite];
    
    sprite = [[[TelephoneLineSprite alloc] initWithWorld:world atLocation:ccpAdd(startingOffset, ccp(750, 400))] autorelease];
    [self.sprites addObject:sprite];
    
    sprite = [self randomPickupWithWorld:world atOffset:ccpAdd(startingOffset, ccp(100, 400))];
    [self.sprites addObject:sprite];
    
    sprite = [self randomPickupWithWorld:world atOffset:ccpAdd(startingOffset, ccp(600, 650))];
    [self.sprites addObject:sprite];
    
    sprite = [[[KillBallSprite alloc] initWithWorld:world atLocation:ccpAdd(startingOffset, ccp(750, 450))] autorelease];
    [self.sprites addObject:sprite];
}

- (id)initPanelWithWorld:(b2World *)world atOffset:(CGPoint)startingOffset {
    self = [super init];
    if(self) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        self.sprites = [NSMutableArray array];
        
        self.backgroundSprite = [CCSprite spriteWithFile:BackgroundName];
        self.backgroundSprite.opacity = 255;
        self.backgroundSprite.position = startingOffset;
        self.backgroundSprite.anchorPoint = ccp(0, 0);
        
        KillZoneSprite *killZone = [[[KillZoneSprite alloc] initWithWorld:world atLocation:ccpAdd(startingOffset, ccp(size.width / 2.0, -100))] autorelease];
        [self.sprites addObject:killZone];
        
        switch ((nextBackground % BackgroundCount)) {
            case 0:
                [self setupPanel1WithWorld:world atOffset:startingOffset];
                break;
            case 1:
                [self setupPanel2WithWorld:world atOffset:startingOffset];
                break;
            case 2:
                [self setupPanel3WithWorld:world atOffset:startingOffset];
                break;
            case 3:
                [self setupPanel4WithWorld:world atOffset:startingOffset];
                break;
            default:
                [self setupPanel1WithWorld:world atOffset:startingOffset];
                break;
        }
        
        nextBackground++;
    }
    return self;
}
- (BOOL)shouldDestroyPanel {
    CGFloat parentX = -(self.backgroundSprite.parent.position.x);
    CGFloat panelX = self.backgroundSprite.position.x + self.backgroundSprite.contentSize.width + BackgroundBuffer;
    if(panelX < parentX) {
        return YES;
    }
    return NO;
}
- (void)destroyPanel {
    [self.backgroundSprite removeFromParentAndCleanup:NO];
    
    for(OmegaSprite *o in self.sprites) {
        //already removed... bad code bad!!!
        if(o.parent) {
            [o removeFromParentAndCleanup:NO];
            o.body->GetWorld()->DestroyBody(o.body);
        }
    }
}
- (void)dealloc {
    self.backgroundSprite = nil;
    self.sprites = nil;
    
    [super dealloc];
}

@end
