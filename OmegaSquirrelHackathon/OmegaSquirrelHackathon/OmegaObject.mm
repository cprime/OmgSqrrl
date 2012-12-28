//
//  OmegaObject.m
//  OmegaSquirrelHackathon
//
//  Created by Patrick Butkiewicz on 12/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "OmegaObject.h"


@implementation OmegaObject

-(id) initWithSprite:(CCSprite *)sprite{
  if( (self=[super init])) {
    _sprite = sprite;
  }
  
  return self;
}

@end
