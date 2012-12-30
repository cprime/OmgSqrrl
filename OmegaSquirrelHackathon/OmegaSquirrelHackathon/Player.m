//
//  Player.m
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/28/12.
//
//

#import "Player.h"
#import "PowerUp.h"

@implementation Player

- (id)init {
    self = [super init];
    if(self) {
        self.baseRunSpeed = 1;
        self.baseJumpPower = 1;
        self.baseMaxHealth = 100;
        
        _currentHealth = self.baseMaxHealth;
        self.activePowerUps = [NSMutableArray arrayWithCapacity:5];
    }
    return self;
}

- (float)currentRunSpeed {
    float ret = self.baseRunSpeed;
    for(PowerUp *powerUp in self.activePowerUps) {
        if(powerUp.type == PowerUpTypeSpeedBoost) {
            ret += powerUp.value;
        }
    }
    return ret;
}
- (float)currentJumpPower {
    float ret = self.baseJumpPower;
    for(PowerUp *powerUp in self.activePowerUps) {
        if(powerUp.type == PowerUpTypeSuperJump) {
            ret += powerUp.value;
        }
    }
    return ret;
}
- (BOOL)isAlive {
    return _currentHealth > 0;
}

- (void)addActivePowerUp:(PowerUp *)powerUp {
    if(powerUp.type == PowerUpTypeHealthBoost) {
        _currentHealth += powerUp.value;
        _currentHealth = MIN(self.baseMaxHealth, _currentHealth);
    } else {
        [self.activePowerUps addObject:powerUp];
    }
}
- (void)takeDamage:(float)damage {
    _currentHealth = MAX(0, _currentHealth - damage);
}

- (void)tick:(float)dt {
    NSMutableArray *powerUpsToRemove = [NSMutableArray array];
    
    for(PowerUp *powerUp in self.activePowerUps) {
        powerUp.elapsedTime += dt;
        if(powerUp.elapsedTime > powerUp.totalTotal) {
            [powerUpsToRemove addObject:powerUp];
        }
    }
    
    [self.activePowerUps removeObjectsInArray:powerUpsToRemove];
}

@end
