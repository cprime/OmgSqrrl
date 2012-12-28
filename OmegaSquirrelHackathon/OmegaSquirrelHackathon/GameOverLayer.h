//
//  GameOverLayer.h
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/28/12.
//
//

#import "CCLayer.h"

@class LevelTracker;

@interface GameOverLayer : CCLayerColor

@property (nonatomic, strong) CCMenu *menu;
@property (nonatomic, strong) LevelTracker *tracker;

+ (CCScene *)sceneWithTracker:(LevelTracker *)tracker;

- (GameOverLayer *)initWithTracker:(LevelTracker *)tracker;

@end
