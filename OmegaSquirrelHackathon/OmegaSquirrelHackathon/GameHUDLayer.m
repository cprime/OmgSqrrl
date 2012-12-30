//
//  GameHUDLayer.m
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/28/12.
//
//

#import "GameHUDLayer.h"
#import "LevelTracker.h"
#import "Player.h"

@interface GameHUDLayer()
@property (nonatomic, strong) CCLabelTTF *timeLabel;
@property (nonatomic, strong) CCLabelTTF *distanceLabel;
@property (nonatomic, strong) CCLabelTTF *acornsLabel;
@property (nonatomic, strong) CCLabelTTF *healthLabel;
@property (nonatomic, strong) CCLabelTTF *speedLabel;
@property (nonatomic, strong) CCLabelTTF *jumpLabel;
@end

@implementation GameHUDLayer

- (void)setTracker:(LevelTracker *)tracker {
    LevelTracker *old = _tracker;
    _tracker = [tracker retain];
    [old release];
    
    [self update];
}

- (void)setPlayer:(Player *)player {
    Player *old = _player;
    _player = [player retain];
    [old release];
    
    [self update];
}

- (CCLabelTTF *)label {
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(200, 50) hAlignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByTruncatingTail fontName:@"Helvetica" fontSize:20];
    label.anchorPoint = ccp(0.0, 1.0);
    label.color = ccWHITE;
    return label;
}

- (id)init {
    self = [super init];
    if(self) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        self.contentSize = size;
        
        CCSprite *topBar = [CCSprite spriteWithFile:@"blank.png"];
        topBar.color = ccRED;
        topBar.anchorPoint = ccp(0, 1.0);
        topBar.position = ccp(0, size.height);
        topBar.textureRect = CGRectMake(0, 0, size.width, 36);
        [self addChild:topBar z:0];
        
        float xOffset = 10;
        
        self.timeLabel = [self label];
        self.timeLabel.position = ccp(xOffset, size.height - 5);
        [self addChild:self.timeLabel z:1];
        
        xOffset += 220;
        
        self.distanceLabel = [self label];
        self.distanceLabel.position = ccp(xOffset, size.height - 5);
        [self addChild:self.distanceLabel z:1];
        
        xOffset += 220;
        
        self.acornsLabel = [self label];
        self.acornsLabel.position = ccp(xOffset, size.height - 5);
        [self addChild:self.acornsLabel z:1];
        
        xOffset += 180;
        
        self.healthLabel = [self label];
        self.healthLabel.position = ccp(xOffset, size.height - 5);
        [self addChild:self.healthLabel z:1];
        
        xOffset += 150;
        
        self.speedLabel = [self label];
        self.speedLabel.position = ccp(xOffset, size.height - 5);
        [self addChild:self.speedLabel z:1];
        
        xOffset += 150;
        
        self.jumpLabel = [self label];
        self.jumpLabel.position = ccp(xOffset, size.height - 5);
        [self addChild:self.jumpLabel z:1];
        
        [self update];
    }
    return self;
}

- (void)update {
    if(self.tracker) {
        _timeLabel.string = [NSString stringWithFormat:@"Secs: %.2f", self.tracker.elapsedTime];
        _distanceLabel.string = [NSString stringWithFormat:@"Meters: %.2f", self.tracker.distanceTraveled / PTM_RATIO];
        _acornsLabel.string = [NSString stringWithFormat:@"Acorns: %d", self.tracker.acornsCollected];
    } else {
        _timeLabel.string = @"";
        _distanceLabel.string = @"";
        _acornsLabel.string = @"";
    }
    
    if(self.player) {
        _healthLabel.string = [NSString stringWithFormat:@"HP: %d", (int)self.player.currentHealth];
        _speedLabel.string = [NSString stringWithFormat:@"SP: %.1fx", self.player.currentRunSpeed];
        _jumpLabel.string = [NSString stringWithFormat:@"JP: %.1fx", self.player.currentJumpPower];
    } else {
        _healthLabel.string = @"";
        _speedLabel.string = @"";
        _jumpLabel.string = @"";
    }
}

@end
