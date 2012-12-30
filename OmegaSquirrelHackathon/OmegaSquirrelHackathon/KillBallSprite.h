//
//  KillBallSprite.h
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/29/12.
//
//

#import "OmegaSprite.h"

@interface KillBallSprite : OmegaSprite

@property (nonatomic, assign) BOOL hasCausedDamage;
@property (nonatomic, assign) int damage;

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location size:(CGSize)size;

@end
