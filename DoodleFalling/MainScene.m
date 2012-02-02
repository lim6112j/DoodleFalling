//
//  MainScene.m
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 7..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import "MainScene.h"
#import "SimpleAudioEngine.h"
#import "OptionMenu.h"
#import "BackgoundLayer.h"

static MainScene *sharedInstance;

@implementation MainScene
@synthesize dic;
+(id)scene
{
    CCScene *scene=[CCScene node];
    MainScene *layer=[MainScene node];
   // BackgoundLayer *bgLayer=[BackgoundLayer node];
   // [scene addChild:bgLayer];
    [scene addChild:layer];
    return scene;
}
+(id)sharedInstance
{
    return sharedInstance;
}
-(id)init
{
    if (self=[super init]) {
        NSLog(@"initialized ");
        collisionSytem=rectCollision; //collision system선택, defaultCollision, rectCollision
        sharedInstance=self;
        self.isAccelerometerEnabled=YES;
        self.isTouchEnabled=YES;
        PlistLoader *loader=[[PlistLoader alloc]init];
        dic=[[loader PlistLoadFromFileName:@"Score"] retain];
        [loader release];
        CCLOG(@"dictionary's retain count is %d",[dic retainCount]);
        [[ UIApplication sharedApplication ] setIdleTimerDisabled: YES ];// 게임중 화면이 검어지거나 아이폰이 lock걸리는걸 방지함.
        screenSize=[[CCDirector sharedDirector]winSize];
        frameCache=[CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"DoodleFall.plist"];
        batch=[CCSpriteBatchNode batchNodeWithFile:@"DoodleFall.png"];
        
        scoreLabel=[CCLabelBMFont labelWithString:@"0" fntFile:@"bitmapfont.fnt"];
        scoreLabel.position=CGPointMake(screenSize.width*0.7f, scoreLabel.contentSize.height);
        CCLabelTTF *meterLabel=[CCLabelTTF labelWithString:@"meter" fontName:@"Arial" fontSize:16];
        meterLabel.position=CGPointMake(scoreLabel.position.x+meterLabel.contentSize.width+scoreLabel.contentSize.width, meterLabel.contentSize.height);
        scoreLabel.anchorPoint=CGPointMake(0.5f, 1.0f);
        CCLabelTTF *pause=[CCLabelTTF labelWithString:@"Touch for Restarting !" fontName:@"Arial" fontSize:32];
        pause.position=CGPointMake(screenSize.width*0.5, screenSize.height*0.5);
        pause.visible=NO;
        [self addChild:scoreLabel z:kScoreLabelZIndex];
        [self addChild:meterLabel z:kScoreLabelZIndex];
        [self addChild:pause z:kScoreLabelZIndex tag:pauseTag];

        CCSprite *menuSprite=[CCSprite spriteWithSpriteFrameName:@"menubutton.png"];
        //  CGSize menuSize=menuSprite.contentSize;
        menuSprite.position=CGPointMake(screenSize.width*0.5, screenSize.height*0.5);
        menuSprite.visible=NO;
        [self addChild:menuSprite z:zIndexOfOptionMenu tag:optionMenuTag];
        
        //[self initWalls];
    
        [self CreateObjectWithType:kTypeLongStair withHealth:100 location:ccp(200.0, 200.0) zValue:1];
        [self CreateObjectWithType:kTypeActor withHealth:100 location:ccp(100.0,100.0) zValue:1];
        [self CreateObjectWithType:kTypeBalloon withHealth:100 location:ccp(0, 0) zValue:0];
        [self CreateObjectWithType:kTypeCeiling withHealth:100 location:ccp(0, 0) zValue:0];
        [self CreateObjectWithType:kTypeHealthBar withHealth:100 location:ccp(0, 0) zValue:0];
        [self CreateObjectWithType:kTypeWall withHealth:0 location:ccp(0, 0) zValue:0];
        [self CreateObjectWithType:kTypeSpeedUpItem withHealth:0 location:ccp(0, 0) zValue:0];
        [self CreateObjectWithType:kTypeFish withHealth:0 location:ccp(0, 0) zValue:0];
        [self CreateObjectWithType:kTypeRollingStair withHealth:0 location:ccp(0,0) zValue:0];
        
 
        [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"madebyBCL.mp3"];
        [self addChild:batch z:1];
        [self scheduleUpdate];

    }
    return self;
}
-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    float deceleration=0.4f;
    float sensitivity=6.0f;
    // float sensitivityY=3.0f;
    float maxVelocity=100;
    float maxVelocityY=50;
    playerVelocity.x=playerVelocity.x*deceleration+acceleration.x*sensitivity;
    if (balloonActivated==YES) {
        playerVelocity.y=playerVelocity.y*deceleration-2.0;
    } else
    {
        playerVelocity.y=playerVelocity.y*deceleration+2.0;   
    }
    
    //NSLog(@"acceleration.y is %f",acceleration.y);
    
    
    if (playerVelocity.x>maxVelocity && playerVelocity.y>maxVelocity) 
    {
        playerVelocity.x=maxVelocity;
        playerVelocity.y=maxVelocityY;
    } 
    else if(playerVelocity.x<-maxVelocity && playerVelocity.y<-maxVelocity) 
    {
        playerVelocity.x=-maxVelocity;
        playerVelocity.y=maxVelocityY;
    }
    //플레이어 좌우 에니메이션 변경
    
    if (playerVelocity.x>=0) {
        actor.flipX=NO;
    } else {
        actor.flipX=YES;
        
    }


}
-(void)update:(ccTime)delta
{


    totalTime+=delta*stair.movingSpeed;
  
    int currentTime=(int)totalTime;
    if (score<currentTime) {
        score=currentTime;
        [scoreLabel setString:[NSString stringWithFormat:@"%i",score]];
    }
    
    CGPoint pos=actor.position;
    pos.x += playerVelocity.x;
    pos.y -= playerVelocity.y;


    CGSize size=[[CCDirector sharedDirector]winSize];
    float playerImageHalf=actor.contentSize.width*0.5;
    float borderRight=size.width-playerImageHalf;
    float borderLeft=playerImageHalf;
    if (pos.x<borderLeft) {
        pos.x=borderLeft;
        playerVelocity.x=0;
    }else if(pos.x>borderRight)
    {
        pos.x=borderRight;
        playerVelocity.x=0;
    }

    if (pos.y<-playerImageHalf || pos.y>ceiling.position.y-ceiling.contentSize.height*0.5) {

        pos=CGPointMake(screenSize.width*0.5, screenSize.height*0.6);
        [self gamePause];
    }
    if (balloonActivated==YES) {
        CCSprite *balloon=(CCSprite *)[self getChildByTag:balloonTag];
        balloon.position=CGPointMake(actor.position.x, actor.position.y+actor.contentSize.height*0.5);
        CGPoint posBall=balloon.position;
        if (posBall.y>ceilingPoint.y-ceilingSize.height*0.5) {
            balloonActivated=NO;
            balloon.visible=NO;
            [self schedule:@selector(resetBalloon) interval:10.0f];
        }
    }
    if (speedUpItem.isActive==YES) 
    {
        speedUpItem.position=CGPointMake(stair.position.x, stair.position.y+stair.contentSize.height*0.4);
    }
    if (speedUpItem.objectState==kStateEatUpItemWearOff) {
        [self changeStairSpeed:kStateEatUpItemWearOff];
    }
    if (fish.isActive==YES) {
        fish.position=CGPointMake(stair.position.x, stair.position.y+stair.contentSize.height*0.4);
    }
    actor.position=pos;
    [self updateHealthBar];
    [wall updateState:delta gameObjects:nil];
    [self checkForCollision:delta];
}
-(void)updateHealthBar
{
    HealthBar *healthBar=(HealthBar *)[self getChildByTag:kHealthBar];
    float scale=actor.health/kInitialHealthFloat;
    [healthBar setScaleX:scale];
    //NSLog(@"healthbar's scale is %f, and health is %d",[healthBar scaleX],[actor health]);
}
-(void)gamePause
{
    //[self resetStairs];

    int hiScore=[[dic objectForKey:@"hiScore"]intValue];
            CCLOG(@"dictionary's retain count is %d in Gamepause method",[dic retainCount]);
  //  NSLog(@"object from dic is %d",[[dic objectForKey:@"hiScore"]intValue]);
    if (score>hiScore) {
        //NSLog(@" current score is %d, high score is %d",score,hiScore);
        hiScore=score;
        [dic setValue:[NSNumber numberWithInt:score] forKey:@"hiScore"];
        NSLog(@"hiscore is %@",[dic objectForKey:@"hiScore"]);
    }
    [self changeStairSpeed:kStateSpeedNormal];
    [self pauseSchedulerAndActions];
    [self resetBalloon];
    [actor setHealth:kInitialHealth];
    ceiling.position=CGPointMake(screenSize.width*0.5, screenSize.height+ceilingSize.height*0.3);
    CCLabelTTF *pause=(CCLabelTTF *)[self getChildByTag:pauseTag];
    CCLabelTTF *scoreDescLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"your Score is %d",score] fontName:@"Arial" fontSize:24];
    scoreDescLabel.position=CGPointMake(screenSize.width*0.5, screenSize.height*0.3);
    [self addChild:scoreDescLabel z:1 tag:scoreDescLabelTag];
    CCLabelTTF *HiScoreDescLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"your Highest Score is %d",hiScore] fontName:@"Arial" fontSize:14];
    HiScoreDescLabel.position=CGPointMake(screenSize.width*0.5, screenSize.height*0.2);
    [self addChild:HiScoreDescLabel z:1 tag:hiScoreDescLabelTag];
    pause.visible=YES;
    totalTime=0;
    score=0;
    gameEnded=YES;
}
-(void)resetBalloon
{
    CCSprite *item=(CCSprite *)[self getChildByTag:balloonTag];
    CCSprite *itemBox=(CCSprite *)[self getChildByTag:itemBoxTag];
    item.position=CGPointMake(itemBox.contentSize.width*1.2, itemBox.contentSize.height);
    item.visible=YES;
    [self unschedule:@selector(resetBalloon)];
}

-(void)checkForCollision:(ccTime)delta
{
    if (collisionSytem==defaultCollision) {

        CCArray *charArray=[batch children];
       // NSLog(@"batch has %d objects",[charArray count]);
        GameCharacter *landedStair=nil;
        for (GameCharacter *tempChar in charArray) 
        {
            if ([tempChar tag]==actorTag)
            {
                [tempChar updateState:delta gameObjects:charArray];
                continue;
            }
            float actualDistanceY=actor.position.y-tempChar.position.y;
            float actualDistanceX=actor.position.x-tempChar.position.x;
            if (actualDistanceX>-tempChar.contentSize.width*0.5 && actualDistanceX<tempChar.contentSize.width*0.5) 
            {
                if (actualDistanceY>0 && actualDistanceY<actor.contentSize.height*0.5) 
                {
                    [actor changeState:kStateLanding];
                    CGPoint pos=actor.position;
                    CGPoint posTempChar=tempChar.position;
                    pos.y=posTempChar.y+[actor modifiedBoundingBox].size.height*0.1;
                    actor.position=pos;
                    landedStair=tempChar;
                    //NSLog(@"landedStair character type is %d,%d",landedStair.gameObjectType,kTypeFlameStair);
                    if (landedStair.gameObjectType==kTypeFlameStair) {
                        [actor changeState:kStateGettingDamageByFire];
                    }
                }
            }
            if (actor.characterState!=kStateLanding) {
                

                //NSLog(@"actor is falling");
            }
            else
            {
               // NSLog(@"actor is landed");
            }
            [tempChar updateState:delta gameObjects:charArray];
        }
        if (landedStair==nil) {
            [actor changeState:kStateFalling];
         //   [ceiling changeState:kStateCeilingUp];
        }
    } else if(collisionSytem==rectCollision)
    {
        CCArray *charArray=[batch children];
        GameCharacter *landedStair=nil;
        for (GameCharacter *tempChar in charArray) {
            if ([tempChar tag]==actorTag) {
                [tempChar updateState:delta gameObjects:charArray];
                continue;
            }

            CGRect actorRect=[actor modifiedBoundingBox];
            CGRect stairRect=[tempChar modifiedBoundingBox];
            CGPoint actorPoint=actor.position;
            CGPoint stairPoint=tempChar.position;
            if (CGRectIntersectsRect(actorRect, stairRect) && actorPoint.y>stairPoint.y) 
            {
                [actor changeState:kStateLanding];
                CGPoint pos=actor.position;
                pos.y=tempChar.position.y+tempChar.contentSize.height*0.5;
                actor.position=pos;
                landedStair=tempChar;
                //NSLog(@"landedStair character type is %d,%d",landedStair.gameObjectType,kTypeFlameStair);
                if (landedStair.gameObjectType==kTypeFlameStair) {
                   // CCLOG(@"actor meets stair on fire");
                    [actor changeState:kStateGettingDamageByFire];
                }
                if (tempChar.gameObjectType==kTypeSpeedUpItem) {
                    CCLOG(@"actor meets speedup item");
                    [tempChar changeState:kStateEatUpItem];
                    [self changeStairSpeed:kStateEatUpItem];
                }
                if (tempChar.gameObjectType==kTypeFish) {
                    CCLOG(@"actor meets fish item");
                    actor.health+=30;
                    [tempChar changeState:kStateEatUpItem];
                }
            }
            if (actor.characterState!=kStateLanding) {
                
                
                //NSLog(@"actor is falling");
            }
            else
            {
                // NSLog(@"actor is landed");
            }

            [tempChar updateState:delta gameObjects:charArray]; // stair를 올린다.
        }
        
        if (landedStair==nil) {
            [actor changeState:kStateFalling];
        }
    }
}
-(void)changeStairSpeed:(ObjectStates)state
{
    CCArray *charArray=[batch children];
    if (state==kStateEatUpItem) {
        for (GameObject *tempObj in charArray) {
            if ([tempObj tag]==actorTag || [tempObj tag]==kTagSpeedUpItem) {
                continue;
            }
            [tempObj changeState:kStateSpeedUp];
        }
    } else if(state==kStateEatUpItemWearOff)
    {
        for (GameObject *tempObj in charArray) {
            if ([tempObj tag]==actorTag || [tempObj tag]==kTagSpeedUpItem) {
                continue;
            }
            [tempObj changeState:kStateSpeedNormal];
        }
    }
}
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint touchPoint=[touch locationInView:[touch view]];
    touchPoint=[[CCDirector sharedDirector]convertToGL:touchPoint];
  //  NSLog(@"touch coord is (%f,%f)",touchPoint.x,touchPoint.y);
    CCSprite *optionMenu=(CCSprite *)[self getChildByTag:optionMenuTag];
    CCSprite *balloon=(CCSprite *)[self getChildByTag:balloonTag];
    CCSprite *itemBox=(CCSprite *)[self getChildByTag:itemBoxTag];
    if (CGRectContainsPoint([optionMenu boundingBox], touchPoint)) {
        [[CCDirector sharedDirector]pushScene:[OptionMenu scene]];

    } 
    if (CGRectContainsRect([itemBox boundingBox], [balloon boundingBox])) {

 
        if (CGRectContainsPoint([itemBox boundingBox], touchPoint))
            {
                balloonActivated=YES;
                balloon.position=CGPointMake(actor.position.x, actor.position.y+actor.contentSize.height*0.5);
            }
    }
        [self resumeSchedulerAndActions];
        CCLabelTTF *pause=(CCLabelTTF *)[self getChildByTag:pauseTag];
        CCLabelTTF *scoreDescLabel=(CCLabelTTF *)[self getChildByTag:scoreDescLabelTag];
        CCLabelTTF *hiScoreDescLabel=(CCLabelTTF *)[self getChildByTag:hiScoreDescLabelTag];
        pause.visible=NO;
        [self removeChild:scoreDescLabel cleanup:YES];
        [self removeChild:hiScoreDescLabel cleanup:YES];
        gameEnded=NO;
    

}
-(void)CreateObjectWithType:(GameObjectTypes)type withHealth:(int)health location:(CGPoint)at zValue:(int)z
{
    if (type==kTypeLongStair) {
        CCLOG(@"creating long type stair");
       
        
        for (int i=0; i<stairNum; i++) {
            int kindOfStair=(int)(CCRANDOM_0_1()+0.5);
            NSString *imageName;
            if (kindOfStair==normalStair) {
                imageName=@"stair.png";
            } else if(kindOfStair==fireStair)
            {
            imageName=@"stairFire.png";
            }
            stair=[[[Stair alloc]initWithImageName:imageName]autorelease];
            if (kindOfStair==normalStair) {
                [stair setGameObjectType:kTypeLongStair];
            } else if(kindOfStair==fireStair)
            {
                [stair setGameObjectType:kTypeFlameStair];
            }

            stair.position=ccp(CCRANDOM_0_1()*(screenSize.width-stair.contentSize.width)+stair.contentSize.width*0.5, screenSize.height*2.0/stairNum*i-screenSize.height-stair.contentSize.height*CCRANDOM_0_1());
            //CGRect stairsize=[stair modifiedBoundingBox];
           // CCLOG(@"stair's modified bounding box width:%f, height:%f, scalenum:%f",stairsize.size.width,stairsize.size.height,stair.scaleX);
            [batch addChild:stair z:0 tag:stairTag];
            [stair release];
        }
 
      
    }  else if (type==kTypeActor)
    {
        actor=[Actor actor];
        actor.health=kInitialHealth;
        actor.delegate=self;
        [batch addChild:actor z:0 tag:actorTag];
    } else if (type==kTypeBalloon)
    {
        CCSprite *itemBox=[CCSprite spriteWithSpriteFrameName:@"itemBox.png"];
        CGSize itemBoxSize=itemBox.contentSize;
        itemBox.position=CGPointMake(itemBoxSize.width*1.2, itemBoxSize.height);
        [self addChild:itemBox z:2 tag:itemBoxTag];
        
        CCSprite *item=[CCSprite spriteWithSpriteFrameName:@"balloon.png"];
        // CGSize itemSize=item.contentSize;
        item.position=CGPointMake(itemBoxSize.width*1.2, itemBoxSize.height);
        [self addChild:item z:2 tag:balloonTag];
    } else if (type==kTypeCeiling)
    {
        ceiling=[[Ceiling alloc]initWithImage];
        ceilingPoint=ceiling.position;
        ceilingSize=ceiling.contentSize;
        [self addChild:ceiling z:2];
    
    } else if (type==kTypeHealthBar)
    {
        HealthBar *healthBar=[[HealthBar alloc]initWithImage];
        healthBar.healthOutline.position=ccp([[CCDirector sharedDirector]winSize].width*0.5, healthBar.contentSize.height*1.1);
        healthBar.position=ccp([[CCDirector sharedDirector]winSize].width*0.5, healthBar.contentSize.height*1.1);
        [self addChild:healthBar z:10 tag:kHealthBar];
        [self addChild:healthBar.healthOutline z:10];
        [healthBar release];

    } else if (type==kTypeWall)
    {
        wall=[[Wall alloc]init];
        [self addChild:wall.wallSprite];
        [self addChild:wall.wallSpriteBelow];

    } else if(type==kTypeSpeedUpItem)
    {
        speedUpItem=[[SpeedUpItem alloc]initWithImage];
        speedUpItem.position=ccp(-100, -100);
        [batch addChild:speedUpItem z:0 tag:kTagSpeedUpItem];
        
    } else if(type==kTypeFish)
    {
        fish=[[[Fish alloc]initWithSpriteFrameName:@"fish_no_BG 1.png"]autorelease];
        fish.scale=[fish scale];
        fish.position=ccp(-100, -100);
        CCAnimation *anim=[fish setAnimation];
        CCAnimate *animate=[CCAnimate actionWithAnimation:anim];
        CCRepeatForever *rep=[CCRepeatForever actionWithAction:animate];
        [fish runAction:rep];
        [batch addChild:fish z:0 tag:kTagFish];
    } else if(type==kTypeRollingStair)
    {
        Item *item=[[Item alloc]init];
        [item setGameObjectType:type];
        [item release];
    }
}

-(void)dealloc
{
    [dic release];
    [speedUpItem release];
    [ceiling release];
    [wall release];
    [super dealloc];
}
@end
