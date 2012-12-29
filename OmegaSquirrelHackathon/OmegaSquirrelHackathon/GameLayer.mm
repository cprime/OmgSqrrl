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
#import "Player.h"
#import "GameHUDLayer.h"
#import "LevelTracker.h"
#import "PowerLine.h"
#import "PowerPole.h"
#import "GamePanel.h"

enum {
	kTagParentNode = 1,
};

enum {
	kZOrderBackground = -1,
    kZOrderBatchNode = 1,
};


#pragma mark - GameLayer

@interface GameLayer()
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
        CGSize s = [[CCDirector sharedDirector] winSize];
		self.isTouchEnabled = YES;
        
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
        
        _squirrel = [[[Squirrel alloc] initWithWorld:world atLocation:ccp(200, 708)] autorelease];
        _squirrel.player = self.playerModel;
        [_batchNode addChild:_squirrel z:INT32_MAX];
        
        //temp
        b2BodyDef groundBodyDef;
        groundBodyDef.position.Set(0, 0); // bottom-left corner
        b2Body* groundBody = world->CreateBody(&groundBodyDef);
        b2EdgeShape groundBox;
        groundBox.Set(b2Vec2(0, 1000 / PTM_RATIO), b2Vec2(s.width/PTM_RATIO, 1000 / PTM_RATIO));
        groundBody->CreateFixture(&groundBox,0);
        
        b2PrismaticJointDef jointDef;
        b2Vec2 worldAxis(1.0f, 0.0f);
        jointDef.collideConnected = true;
        jointDef.Initialize(_squirrel.body, groundBody,
                            _squirrel.body->GetWorldCenter(), worldAxis);
        world->CreateJoint(&jointDef);
        
        [self scheduleUpdate];
	}
    
	return self;
}

- (void)onEnterTransitionDidFinish {
    [self.parent addChild:self.HUDLayer z:100];
    
    [_squirrel run];
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
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	world->DrawDebugData();
	
	kmGLPopMatrix();
}

- (void)update:(ccTime)dt
{
    int32 velocityIterations = 3;
    int32 positionIterations = 2;
    
    world->Step(dt, velocityIterations, positionIterations);
    for(b2Body *b=world->GetBodyList(); b!=NULL; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            OmegaObject *sprite = (OmegaObject *) b->GetUserData();
            sprite.position = ccp(b->GetPosition().x * PTM_RATIO,
                                  b->GetPosition().y * PTM_RATIO);
            sprite.rotation =
            CC_RADIANS_TO_DEGREES(b->GetAngle() * -1);
        }
    }
    
    [self followSquirrel];
    [self updatePanels];
    
    self.levelTracker.distanceTraveled = (_squirrel.body->GetPosition().x - (200 / PTM_RATIO)) * 10;
    self.levelTracker.elapsedTime += dt;
    [self.HUDLayer update];
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
    
    [_squirrel jump];
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
    for(OmegaObject *o in panel.sprites) {
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
    NSLog(@"beginContact");
}
- (void)endContact:(b2Contact*)contact {
    NSLog(@"endContact");
    
}
- (void)preSolve:(b2Contact*)contact manifold:(const b2Manifold*)oldManifold {
    NSLog(@"preSolve");
    b2Body* bodyA = contact->GetFixtureA()->GetBody();
    b2Body* bodyB = contact->GetFixtureB()->GetBody();
    
    OmegaObject* spriteA = (OmegaObject*)bodyA->GetUserData();
    OmegaObject* spriteB = (OmegaObject*)bodyB->GetUserData();
    
    if (spriteA.ethereal || spriteB.ethereal) {
        contact->SetEnabled(false);
        return;
    }
}
- (void)postSolve:(b2Contact*)contact impulse:(const b2ContactImpulse*)impulse {
    NSLog(@"postSolve");
}

@end
