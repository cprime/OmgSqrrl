//
//  PowerUpSprite.h
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/29/12.
//
//

#import "OmegaSprite.h"

@class PowerUp;

@interface PowerUpSprite : OmegaSprite

@property (nonatomic, strong) PowerUp *powerUp;
@property (nonatomic, assign) BOOL hasPickedUp;

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location;
- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location powerUp:(PowerUp *)powerUp;

@end
