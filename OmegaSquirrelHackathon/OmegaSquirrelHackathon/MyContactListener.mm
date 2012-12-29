//
//  MyContactListener.cpp
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/29/12.
//
//

#include "MyContactListener.h"

void MyContactListener::BeginContact(b2Contact* contact) {
    [delegate beginContact:contact];
}

void MyContactListener::EndContact(b2Contact* contact) {
    [delegate endContact:contact];
}

void MyContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold) {
    [delegate preSolve:contact manifold:oldManifold];
}

void MyContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse)  {
    [delegate postSolve:contact impulse:impulse];
}