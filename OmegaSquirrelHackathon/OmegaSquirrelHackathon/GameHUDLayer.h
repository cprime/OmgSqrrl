//
//  GameHUDLayer.h
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/28/12.
//
//

#import "CCLayer.h"

@class LevelTracker;
@class Player;

@interface GameHUDLayer : CCLayer

@property (nonatomic, strong) LevelTracker *tracker;
@property (nonatomic, strong) Player *player;

- (void)update;

@end
