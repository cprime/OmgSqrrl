//
//  GameLayer.mm
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/27/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

// Import the interfaces
#import "GameLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "GameOverLayer.h"
#import "Player.h"
#import "GameHUDLayer.h"
#import "LevelTracker.h"
#import "TelephoneLineSprite.h"
#import "TelephonePoleSprite.h"
#import "GamePanel.h"
#import "KillBallSprite.h"
#import "KillZoneSprite.h"
#import "AcornSprite.h"
#import "PowerUpSprite.h"
#import "LargeHouseSprite.h"

enum {
	kTagParentNode = 1,
};

enum {
	kZOrderBackground = -1,
    kZOrderBatchNode = 1,
};


#pragma mark - GameLayer

@interface GameLayer()
@property (nonatomic, retain) NSMutableArray *spritesToRemove;
@property (nonatomic, assign) MyContactListener *contactListener;
@property (nonatomic, retain) GamePanel *prevPanel;
@property (nonatomic, retain) GamePanel *currPanel;
@property (nonatomic, retain) GamePanel *nextPanel;
- (void)initPanels;
- (void)addPanel:(GamePanel *)panel;
- (void)updatePanels;

- (void)initPhysics;
@end

@implementation GameLayer

- (void)followSquirrel {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    float fixedPosition = winSize.width/4;
    float newX = fixedPosition - _squirrel.position.x;
//    newX = MIN(newX, fixedPosition);
//    newX = MAX(newX, -0/*groundMaxX*/-fixedPosition);
    CGPoint newPos = ccp(newX, self.position.y);
    [self setPosition:newPos];
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id)init
{
	if( (self = [super init])) {
        [GamePanel reset];
        
		self.isTouchEnabled = YES;
        self.spritesToRemove = [NSMutableArray array];
        
        self.playerModel = [[Player alloc] init];
        self.levelTracker = [[LevelTracker alloc] init];
        
        self.HUDLayer = [[GameHUDLayer alloc] init];
        self.HUDLayer.tracker = self.levelTracker;
        self.HUDLayer.player = self.playerModel;
        
		[self initPhysics];
        self.contactListener = new MyContactListener();
        self.contactListener->delegate = self;
        world->SetContactListener(self.contactListener);
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"OmegaSquirrelTextures.plist"];
        _batchNode = [CCSpriteBatchNode batchNodeWithFile:@"OmegaSquirrelTextures.png"];
        [self addChild:_batchNode z:kZOrderBatchNode];
        [self initPanels];
        
        _squirrel = [[[SquirrelSprite alloc] initWithWorld:world atLocation:ccp(200, 708)] autorelease];
        _squirrel.player = self.playerModel;
        [_batchNode addChild:_squirrel z:INT32_MAX - 1];
        
//        //temp
//        CGSize s = [[CCDirector sharedDirector] winSize];
//        b2BodyDef groundBodyDef;
//        groundBodyDef.position.Set(0, 0); // bottom-left corner
//        b2Body* groundBody = world->CreateBody(&groundBodyDef);
//        b2EdgeShape groundBox;
//        groundBox.Set(b2Vec2(0, 1000 / PTM_RATIO), b2Vec2(s.width/PTM_RATIO, 1000 / PTM_RATIO));
//        groundBody->CreateFixture(&groundBox,0);
//        
//        b2PrismaticJointDef jointDef;
//        b2Vec2 worldAxis(1.0f, 0.0f);
//        jointDef.collideConnected = true;
//        jointDef.Initialize(_squirrel.body, groundBody,
//                            _squirrel.body->GetWorldCenter(), worldAxis);
//        world->CreateJoint(&jointDef);
        
        [self scheduleUpdate];
	}
    
	return self;
}

- (void)onEnterTransitionDidFinish {
    [self.parent addChild:self.HUDLayer z:100];
}

-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
	
	[super dealloc];
}

- (void)initPhysics
{
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	world = new b2World(gravity);
	
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	
	world->SetContinuousPhysics(true);
	
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
    flags += b2Draw::e_jointBit;
    flags += b2Draw::e_aabbBit;
    flags += b2Draw::e_pairBit;
    flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);
}

-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
//	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
//	
//	kmGLPushMatrix();
//	
//	world->DrawDebugData();
//	
//	kmGLPopMatrix();
}

- (void)update:(ccTime)dt
{
    int32 velocityIterations = 3;
    int32 positionIterations = 2;
    
    world->Step(dt, velocityIterations, positionIterations);
    for(b2Body *b=world->GetBodyList(); b!=NULL; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            OmegaSprite *sprite = (OmegaSprite *) b->GetUserData();
            sprite.position = ccp(b->GetPosition().x * PTM_RATIO,
                                  b->GetPosition().y * PTM_RATIO);
            sprite.rotation =
            CC_RADIANS_TO_DEGREES(b->GetAngle() * -1);
        }
    }
    [self.playerModel tick:dt];
    
    NSLog(_squirrel.feetContactCount > 0 ? @"Ground" : @"Not");
    if(_squirrel.feetContactCount == 1 /*&& !_squirrel.hasRestarted*/) {
        [_squirrel run];
        _squirrel.hasRestarted = YES;
    }
    
    for(OmegaSprite *o in self.spritesToRemove) {
//        [o removeFromParentAndCleanup:NO];
//        world->DestroyBody(o.body);
        o.opacity = 0;
    }
    [self.spritesToRemove removeAllObjects];
    
    [self followSquirrel];
    [self updatePanels];
    
    self.levelTracker.distanceTraveled = (_squirrel.body->GetPosition().x - (200 / PTM_RATIO)) * 10;
    self.levelTracker.elapsedTime += dt;
    [self.HUDLayer update];
    
    if(_playerModel.currentHealth <= 0) {
        self.isTouchEnabled = NO;
        [self unscheduleUpdate];
        _squirrel.rotation = 180;
        [_squirrel stopAllActions];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF *label = [[CCLabelTTF alloc] initWithString:@"You're Dead, Omega!" fontName:@"Helvetica" fontSize:72];
        label.color = ccYELLOW;
        label.anchorPoint = ccp(.5, .5);
        label.position = ccpAdd(ccpSub(CGPointZero, self.position), ccp(winSize.width / 2.0, winSize.height / 2.0));
        label.scale = .25;
        [self addChild:label z:INT32_MAX];
        
        [label runAction:[CCSequence actions:
                          [CCScaleTo actionWithDuration:.5 scale:1],
                          [CCDelayTime actionWithDuration:3],
                          [CCCallBlock actionWithBlock:^{
            CCScene *scene = [GameOverLayer sceneWithTracker:self.levelTracker];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene withColor:ccBLACK]];
        }],
                          nil]];
    }
}

- (void)setOffsetX:(float)newOffsetX{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    _offsetX = newOffsetX;
    
    self.position = CGPointMake(winSize.width/8 - _offsetX * self.scale, 0);
}

#pragma mark - TOUCH EVENTS
// The touch events set one boolean variable that is analyzed inside the 'update'
// function. The update function will determine what to do with the character
// depending on this variable

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _tapDown = YES;
    
    if(_squirrel.feetContactCount > 0 || !_squirrel.hasDoubleJumped) {
        if(_squirrel.feetContactCount == 0) {
            _squirrel.hasDoubleJumped = YES;
        }
        [_squirrel jump];
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    _tapDown = NO;
    
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	_tapDown = NO;
}

#pragma mark - panels

- (void)addPanel:(GamePanel *)panel {
    [self addChild:panel.backgroundSprite z:kZOrderBackground];
    for(OmegaSprite *o in panel.sprites) {
        [_batchNode addChild:o z:0];
    }
}

- (void)initPanels {
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    self.prevPanel = [[GamePanel alloc] initPanelWithWorld:world atOffset:ccp(-s.width, 0)];
    [self addPanel:self.prevPanel];
    
    self.currPanel = [[GamePanel alloc] initPanelWithWorld:world atOffset:ccp(0, 0)];
    [self addPanel:self.currPanel];
    
    self.nextPanel = [[GamePanel alloc] initPanelWithWorld:world atOffset:ccp(s.width, 0)];
    [self addPanel:self.nextPanel];
}
- (void)updatePanels {
    if([self.prevPanel shouldDestroyPanel]) {
        CGSize s = [[CCDirector sharedDirector] winSize];
        
        [self.prevPanel destroyPanel];
        
        self.prevPanel = self.currPanel;
        self.currPanel = self.nextPanel;
        
        self.nextPanel = [[GamePanel alloc] initPanelWithWorld:world atOffset:ccp(self.currPanel.backgroundSprite.position.x + s.width, 0)];
        [self addPanel:self.nextPanel];
    }
}

#pragma mark - contact listener

- (void)beginContact:(b2Contact*)contact {
//    NSLog(@"beginContact");
    
    if(contact->IsTouching()) {
        b2Fixture* fixtureA = contact->GetFixtureA();
        b2Fixture* fixtureB = contact->GetFixtureB();
        
        b2Body* bodyA = fixtureA->GetBody();
        b2Body* bodyB = fixtureB->GetBody();
        
        OmegaSprite* spriteA = (OmegaSprite*)bodyA->GetUserData();
        OmegaSprite* spriteB = (OmegaSprite*)bodyB->GetUserData();
        
        SquirrelSprite* squirrel = nil;
        OmegaSprite* other = nil;
        b2Fixture* squirrelFixture = nil;
        
        if([spriteA isKindOfClass:[SquirrelSprite class]] && ![spriteB isKindOfClass:[SquirrelSprite class]]) {
            squirrel = (SquirrelSprite *)spriteA;
            squirrelFixture = fixtureA;
            other = spriteB;
        } else if(![spriteA isKindOfClass:[SquirrelSprite class]] && [spriteB isKindOfClass:[SquirrelSprite class]]) {
            squirrel = (SquirrelSprite *)spriteB;
            squirrelFixture = fixtureB;
            other = spriteA;
        }
        
        if(squirrel) {
            if([other isKindOfClass:[KillBallSprite class]]) {
                [self.playerModel takeDamage:[(KillBallSprite *)other damage]];
                [(KillBallSprite *)other setHasCausedDamage:YES];
                _squirrel.hasDoubleJumped = NO;
            }
            if([other isKindOfClass:[KillZoneSprite class]]) {
                [self.playerModel takeDamage:self.playerModel.currentHealth];
            }
            if([other isKindOfClass:[AcornSprite class]] && ![(AcornSprite *)other hasPickedUp]) {
                self.levelTracker.acornsCollected += [(AcornSprite *)other value];
                [self.spritesToRemove addObject:other];
                [(AcornSprite *)other setHasPickedUp:YES];
            }
            if([other isKindOfClass:[PowerUpSprite class]] && ![(AcornSprite *)other hasPickedUp]) {
                [self.playerModel addActivePowerUp:[(PowerUpSprite *)other powerUp]];
                [self.spritesToRemove addObject:other];
                [(PowerUpSprite *)other setHasPickedUp:YES];
            }
            if(squirrelFixture == squirrel.feet) {
                if([other isKindOfClass:[TelephoneLineSprite class]] || [other isKindOfClass:[TelephonePoleSprite class]] || [other isKindOfClass:[LargeHouseSprite class]]) {
                    squirrel.feetContactCount++;
                }
            }
        }
    }
}
- (void)endContact:(b2Contact*)contact {
//    NSLog(@"endContact");
    
    if(!contact->IsTouching()) {
        b2Fixture* fixtureA = contact->GetFixtureA();
        b2Fixture* fixtureB = contact->GetFixtureB();
        
        b2Body* bodyA = fixtureA->GetBody();
        b2Body* bodyB = fixtureB->GetBody();
        
        OmegaSprite* spriteA = (OmegaSprite*)bodyA->GetUserData();
        OmegaSprite* spriteB = (OmegaSprite*)bodyB->GetUserData();
        
        SquirrelSprite* squirrel = nil;
        OmegaSprite* other = nil;
        b2Fixture* squirrelFixture = nil;
        
        if([spriteA isKindOfClass:[SquirrelSprite class]] && ![spriteB isKindOfClass:[SquirrelSprite class]]) {
            squirrel = (SquirrelSprite *)spriteA;
            squirrelFixture = fixtureA;
            other = spriteB;
        } else if(![spriteA isKindOfClass:[SquirrelSprite class]] && [spriteB isKindOfClass:[SquirrelSprite class]]) {
            squirrel = (SquirrelSprite *)spriteB;
            squirrelFixture = fixtureB;
            other = spriteA;
        }
        
        if(squirrel) {
            if([other isKindOfClass:[KillBallSprite class]]) {
                [(KillBallSprite *)other setHasCausedDamage:NO];
            }
            if(squirrelFixture == squirrel.feet) {
                if([other isKindOfClass:[TelephoneLineSprite class]] || [other isKindOfClass:[TelephonePoleSprite class]] || [other isKindOfClass:[LargeHouseSprite class]]) {
                    squirrel.feetContactCount--;
                    if(squirrel.feetContactCount <= 0) {
                        _squirrel.hasRestarted = NO;
                    }
                }
            }
        }
    }
    
}
- (void)preSolve:(b2Contact*)contact manifold:(const b2Manifold*)oldManifold {
//    NSLog(@"preSolve");
    b2Body* bodyA = contact->GetFixtureA()->GetBody();
    b2Body* bodyB = contact->GetFixtureB()->GetBody();
    
    OmegaSprite* spriteA = (OmegaSprite*)bodyA->GetUserData();
    OmegaSprite* spriteB = (OmegaSprite*)bodyB->GetUserData();
    
    if (spriteA.ethereal || spriteB.ethereal) {
        contact->SetEnabled(false);
        return;
    }
}
- (void)postSolve:(b2Contact*)contact impulse:(const b2ContactImpulse*)impulse {
//    NSLog(@"postSolve");
}

@end
