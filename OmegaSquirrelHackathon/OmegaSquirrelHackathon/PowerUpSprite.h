//
//  PowerUpSprite.h
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/29/12.
//
//

#import "OmegaObject.h"

@class PowerUp;

@interface PowerUpSprite : OmegaObject

@property (nonatomic, strong) PowerUp *powerUp;

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location;
- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location powerUp:(PowerUp *)powerUp;

@end
