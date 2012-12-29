//
//  PowerUp.h
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/28/12.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    PowerUpTypeHealthBoost,
    PowerUpTypeSuperJump,
    PowerUpTypeSpeedBoost,
} PowerUpType;

@interface PowerUp : NSObject

@property (nonatomic, assign) PowerUpType type;
@property (nonatomic, assign) float elapsedTime;
@property (nonatomic, assign) float totalTotal;
@property (nonatomic, assign) float value;

+ (PowerUp *)powerUpWithType:(PowerUpType)type;

@end
