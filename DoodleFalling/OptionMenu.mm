//
//  OptionMenu.m
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 11..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import "OptionMenu.h"
#import "MainScene.h"
#import "SimpleAudioEngine.h"

@implementation OptionMenu
+(id)scene
{
    CCScene *scene=[CCScene node];
    OptionMenu *layer=[OptionMenu node];
    [scene addChild:layer];
    return scene;
}
-(id)init
{
    if (self=[super init]) {
        NSLog(@"option menu started");
        self.isTouchEnabled=YES;
        CGSize screenSize=[[CCDirector sharedDirector]winSize];
        CCSprite *BG=[CCSprite spriteWithFile:@"optionBG.png"];
        BG.position=CGPointMake(screenSize.width*0.5, screenSize.height*0.5);
        [self addChild:BG];
        CCLabelTTF *soundLabel=[CCLabelTTF labelWithString:@"Sound" fontName:@"Arial" fontSize:24];
        soundLabel.position=CGPointMake(screenSize.width*0.5, screenSize.height*0.4);
        if ([[SimpleAudioEngine sharedEngine]isBackgroundMusicPlaying]==YES) {
            soundLabel.color=ccWHITE;
        } else
        {
            soundLabel.color=ccGRAY;
        }
        [self addChild:soundLabel z:0 tag:soundLabelTag];
        CCLabelTTF *resumeLabel=[CCLabelTTF labelWithString:@"Resume Game" fontName:@"Arial" fontSize:24];
        resumeLabel.position=CGPointMake(screenSize.width*0.5, screenSize.height*0.3);
        [self addChild:resumeLabel z:0 tag:resumeLabelTag];
    }
    return self;
}
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint location=[touch locationInView:[touch view]];
    location=[[CCDirector sharedDirector]convertToGL:location];
    //NSLog(@"touch location is (%f,%f)",location.x,location.y);
    CCLabelTTF *resume=(CCLabelTTF *)[self getChildByTag:resumeLabelTag];
    CCLabelTTF *sound=(CCLabelTTF *)[self getChildByTag:soundLabelTag];
    if (CGRectContainsPoint([sound boundingBox], location)) {
        if ([[SimpleAudioEngine sharedEngine]isBackgroundMusicPlaying]==YES) {
            [[SimpleAudioEngine sharedEngine]pauseBackgroundMusic];
            sound.color=ccGRAY;
        } else   
        {

            [[SimpleAudioEngine sharedEngine]resumeBackgroundMusic];
            sound.color=ccWHITE;
        }

    }
    if (CGRectContainsPoint([resume boundingBox], location)) {
            [[CCDirector sharedDirector] popScene];
    }

}
-(void)dealloc
{
    [super dealloc];
}
@end
