//
//  AcornSprite.h
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/29/12.
//
//

#import "OmegaSprite.h"

typedef enum {
    AcornTypeOne,
    AcornTypeThree,
    AcornTypeTen,
} AcornType;

@interface AcornSprite : OmegaSprite

@property (nonatomic, assign) AcornType type;
@property (nonatomic, readonly) int value;

- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location;
- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)location type:(AcornType)type;

@end
