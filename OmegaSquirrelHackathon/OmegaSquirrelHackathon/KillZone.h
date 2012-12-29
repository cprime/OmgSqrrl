//
//  KillZone.h
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/29/12.
//
//

#import "OmegaObject.h"

@interface KillZone : OmegaObject

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location size:(CGSize)size;

@end
