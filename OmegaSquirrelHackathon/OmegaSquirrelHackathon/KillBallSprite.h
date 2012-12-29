//
//  KillBallSprite.h
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/29/12.
//
//

#import "OmegaObject.h"

@interface KillBallSprite : OmegaObject

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location size:(CGSize)size;

@end
