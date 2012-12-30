//
//  GamePanel.h
//  OmegaSquirrelHackathon
//
//  Created by Colden Prime on 12/29/12.
//
//

#import "cocos2d.h"
#import "Box2D.h"

@interface GamePanel : NSObject

@property (nonatomic, retain) CCSprite *backgroundSprite;
@property (nonatomic, retain) NSMutableArray *sprites;

+ (void)reset;

- (id)initPanelWithWorld:(b2World *)world atOffset:(CGPoint)startingOffset;
- (BOOL)shouldDestroyPanel;
- (void)destroyPanel;

@end
