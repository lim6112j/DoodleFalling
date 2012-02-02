//
//  MainMenu.m
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 14..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import "MainMenu.h"
#import "MainScene.h"


@implementation MainMenu
+(id)scene
{
    CCScene *scene=[CCScene node];
    MainMenu *layer=[MainMenu node];
    [scene addChild:layer];
    return scene;
}
-(id)init
{
    if (self=[super init]) {
        self.isTouchEnabled=YES;
        size=[[CCDirector sharedDirector]winSize];
        CCSprite *BG=[CCSprite spriteWithFile:@"optionBG.png"];
        BG.position=CGPointMake(size.width*0.5, size.height*0.5);
        [self addChild:BG];
        CCLabelTTF *startLabel=[CCLabelTTF labelWithString:@"Start" fontName:@"Arial" fontSize:24];
        startLabel.position=CGPointMake(size.width*0.5, size.height*0.4);
        [self addChild:startLabel z:0 tag:startLabelTag];
    }
    return self;
}
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint touchPoint=[touch locationInView:[touch view]];
    touchPoint=[[CCDirector sharedDirector]convertToGL:touchPoint];
    CCLabelTTF *startLabel=(CCLabelTTF *)[self getChildByTag:startLabelTag];
    if (CGRectContainsPoint([startLabel boundingBox], touchPoint)) {
         
        [[CCDirector sharedDirector]replaceScene:[MainScene scene]];
    }
}
-(void)dealloc
{
    [super dealloc];
}
@end
