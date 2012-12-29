//
//  Player.h
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/28/12.
//
//

#import <Foundation/Foundation.h>

@class PowerUp;

@interface Player : NSObject

@property (nonatomic, assign) float baseRunSpeed;
@property (nonatomic, assign) float baseJumpPower;
@property (nonatomic, assign) float baseMaxHealth;

@property (nonatomic, strong) NSMutableArray *activePowerUps;

@property (nonatomic, readonly) float currentHealth;
@property (nonatomic, readonly) float currentRunSpeed;
@property (nonatomic, readonly) float currentJumpPower;
@property (nonatomic, readonly) BOOL isAlive;

- (void)addActivePowerUp:(PowerUp *)powerUp;
- (void)takeDamage:(float)damage;

- (void)tick:(float)dt;

@end
