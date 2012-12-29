//
//  MyContactListener.h
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/29/12.
//
//

#ifndef __OmegaSquirrelHackathon__MyContactListener__
#define __OmegaSquirrelHackathon__MyContactListener__

#import "Box2D.h"

@protocol B2ContactListener <NSObject>

- (void)beginContact:(b2Contact*)contact;
- (void)endContact:(b2Contact*)contact;
- (void)preSolve:(b2Contact*)contact manifold:(const b2Manifold*)oldManifold;
- (void)postSolve:(b2Contact*)contact impulse:(const b2ContactImpulse*)impulse;

@end

class MyContactListener : public b2ContactListener
{
public:
    id<B2ContactListener> delegate;
    
    void BeginContact(b2Contact* contact);
    void EndContact(b2Contact* contact);
    void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
    void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
};

#endif /* defined(__OmegaSquirrelHackathon__MyContactListener__) */
