//
//  MainMenuLayer.m
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/28/12.
//
//

#import "MainMenuLayer.h"
#import "HelloWorldLayer.h"

//temp
#import "GameOverLayer.h"
#import "LevelTracker.h"

@implementation MainMenuLayer

- (void)playButtonClicked {
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenuLayer *layer = [MainMenuLayer node];
	
	// add layer as a child to scene
	[scene addChild:layer];
	
	// return the scene
	return scene;
}

- (id)init {
    self = [super initWithColor:ccc4(0, 0, 0, 255)];
    if(self) {
        self.contentSize = CGSizeMake(1024, 768);
        
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
                text = @"Play Game?";
                break;
        }
        
        CCMenuItem *playButton = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:text fontName:@"Helvetica" fontSize:30]];
        [playButton setTarget:self selector:@selector(playButtonClicked)];
        
        CCMenu *menu = [CCMenu menuWithItems:playButton, nil];
        menu.position = ccp(self.contentSize.width / 2.0, self.contentSize.height / 2.0);
        
        [menu alignItemsVertically];
        
        [self addChild:menu];
    }
    return self;
}

@end
