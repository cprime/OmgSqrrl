//
//  PowerUp.m
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/28/12.
//
//

#import "PowerUp.h"

@implementation PowerUp

+ (PowerUp *)powerUpWithType:(PowerUpType)type {
    PowerUp *ret = [[[PowerUp alloc] init] autorelease];
    ret.elapsedTime = 0;
    ret.type = type;
    
    switch (type) {
        case PowerUpTypeHealthBoost:
            ret.totalTotal = 0;
            ret.value = 20;
            break;
        case PowerUpTypeSuperJump:
            ret.totalTotal = 5;
            ret.value = .5;
            break;
        case PowerUpTypeTripleJump:
            ret.totalTotal = 5;
            ret.value = 0;
            break;
        case PowerUpTypeSpeedBoost:
            ret.totalTotal = 5;
            ret.value = .5;
            break;
    }
    
    return ret;
}

@end
