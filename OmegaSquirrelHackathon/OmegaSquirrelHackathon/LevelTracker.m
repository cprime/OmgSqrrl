//
//  LevelTracker.m
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/28/12.
//
//

#import "LevelTracker.h"

@implementation LevelTracker

- (id)init {
    self = [super init];
    if(self) {
        _elapsedTime = 0;
        _distanceTraveled = 0;
        _acornsCollected = 0;
    }
    return self;
}

@end
