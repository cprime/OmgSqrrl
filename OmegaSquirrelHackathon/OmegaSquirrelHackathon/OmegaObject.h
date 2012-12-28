//
//  OmegaObject.h
//  OmegaSquirrelHackathon
//
//  Created by Patrick Butkiewicz on 12/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

@interface OmegaObject : CCNode {
  b2Body *body_;
  CCSprite *_sprite;
}

- (id)initWithSprite:(CCSprite *)sprite;

@end
