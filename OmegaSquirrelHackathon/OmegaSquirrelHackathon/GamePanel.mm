//
//  GamePanel.m
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/29/12.
//
//

#import "GamePanel.h"
#import "OmegaObject.h"
#import "PowerPole.h"
#import "KillZone.h"

#define BackgroundCount 4
#define BackgroundName [NSString stringWithFormat:@"Omega_ipad_bckgrnd_%d.png", (nextBackground % BackgroundCount) + 1]
static int nextBackground = 3;

#define BackgroundBuffer 50

@implementation GamePanel

- (void)setupPanelAWithWorld:(b2World *)world atOffset:(CGPoint)startingOffset {
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    KillZone *killZone = [[[KillZone alloc] initWithWorld:world atLocation:ccpAdd(startingOffset, ccp(size.width / 2.0, -100))] autorelease];
    [self.sprites addObject:killZone];
    
    PowerPole *pole = [[[PowerPole alloc] initWithWorld:world atLocation:ccpAdd(startingOffset, ccp(400, 200))] autorelease];
    [self.sprites addObject:pole];
}

- (id)initPanelWithWorld:(b2World *)world atOffset:(CGPoint)startingOffset {
    self = [super init];
    if(self) {
        self.sprites = [NSMutableArray array];
        
        self.backgroundSprite = [CCSprite spriteWithFile:BackgroundName];
        self.backgroundSprite.opacity = 255;
        self.backgroundSprite.position = startingOffset;
        self.backgroundSprite.anchorPoint = ccp(0, 0);
        nextBackground++;
        
        [self setupPanelAWithWorld:world atOffset:startingOffset];
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
    
    for(OmegaObject *o in self.sprites) {
        [o removeFromParentAndCleanup:NO];
        o.body->GetWorld()->DestroyBody(o.body);
    }
}
- (void)dealloc {
    self.backgroundSprite = nil;
    self.sprites = nil;
    
    [super dealloc];
}

@end
