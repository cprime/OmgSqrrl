//
//  GameOverLayer.m
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/28/12.
//
//

#import "GameOverLayer.h"
#import "LevelTracker.h"
#import "HelloWorldLayer.h"

@implementation GameOverLayer

- (void)playButtonClicked {
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
}

+ (CCScene *)sceneWithTracker:(LevelTracker *)tracker {
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOverLayer *layer = [[GameOverLayer alloc] initWithTracker:tracker];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (GameOverLayer *)initWithTracker:(LevelTracker *)tracker {
    if((self = [super init])) {
        self.contentSize = CGSizeMake(1024, 768);
        
        CCMenuItem *timeLabel = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Run time: %f seconds", tracker.elapsedTime]
                                                                                  fontName:@"Helvetica"
                                                                                  fontSize:30]];
        CCMenuItem *distanceLabel = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Distance Traveled: %f meters", tracker.distanceTraveled / PTM_RATIO]
                                                                                      fontName:@"Helvetica"
                                                                                      fontSize:30]];
        CCMenuItem *acornsLabel = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Acorns Collected: %d", tracker.acornsCollected]
                                                                                    fontName:@"Helvetica"
                                                                                    fontSize:30]];
        CCMenuItem *space = [[CCMenuItem alloc] init];
        space.contentSize = CGSizeMake(1, 100);
        
        NSString *text = nil;
        switch (arc4random() % 8) {
            case 0:
                text = @"Appease the Alpha Squirrel?";
                break;
            case 1:
                text = @"Curry favor with Lady Squirrel?";
                break;
            case 2:
                text = @"Avoid Alpha Squirrel's Retribution?";
                break;
            case 3:
                text = @"Gather nuts for Squirrel Pack?";
                break;
            default:
                text = @"Play Again?";
                break;
        }
        
        CCMenuItem *playButton = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:text fontName:@"Helvetica" fontSize:50]];
        [playButton setTarget:self selector:@selector(playButtonClicked)];
        
        CCMenu *menu = [CCMenu menuWithItems:timeLabel, distanceLabel, acornsLabel, space, playButton, nil];
        menu.position = ccp(self.contentSize.width / 2.0, self.contentSize.height / 2.0);
        
        [menu alignItemsVertically];
        
        [self addChild:menu];
    }
	return self;
}

@end
