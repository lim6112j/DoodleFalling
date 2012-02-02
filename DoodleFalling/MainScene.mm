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
        
        collisionSystem=rectCollision; //collision system선택, defaultCollision, rectCollision
        self.isAccelerometerEnabled=YES;
        self.isTouchEnabled=YES;
        speedUpItemActivated=NO;
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
        

        [self setUpWorld];
        
        // Create contact listener
        _contactListener = new MyContactListener();
        _world->SetContactListener(_contactListener);
        
        
        [self CreateObjectWithType:kTypeLongStair withHealth:100 location:ccp(200.0, 200.0) zValue:1];
        [self CreateObjectWithType:kTypeActor withHealth:100 location:ccp(100.0,100.0) zValue:1];
        [self CreateObjectWithType:kTypeBalloon withHealth:100 location:ccp(0, 0) zValue:0];
        [self CreateObjectWithType:kTypeCeiling withHealth:100 location:ccp(0, 0) zValue:0];
        [self CreateObjectWithType:kTypeHealthBar withHealth:100 location:ccp(0, 0) zValue:0];
        [self CreateObjectWithType:kTypeWall withHealth:0 location:ccp(0, 0) zValue:0];
        [self CreateObjectWithType:kTypeSpeedUpItem withHealth:0 location:ccp(0, 0) zValue:0];
        [self CreateObjectWithType:kTypeFish withHealth:0 location:ccp(0, 0) zValue:0];
        [self CreateObjectWithType:kTypeRollingStair withHealth:0 location:ccp(0,0) zValue:0];
        
        // Enable debug draw
        _debugDraw = new GLESDebugDraw( PTM_RATIO );
        _world->SetDebugDraw(_debugDraw);
        
        uint32 flags = 0;
         //       flags += b2DebugDraw::e_shapeBit;
        //		flags += b2DebugDraw::e_jointBit;
        //		flags += b2DebugDraw::e_aabbBit;
        //		flags += b2DebugDraw::e_pairBit;
        //		flags += b2DebugDraw::e_centerOfMassBit;
        _debugDraw->SetFlags(flags);
        
        [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"madebyBCL.mp3"];
        [self addChild:batch z:1];
        [self scheduleUpdate];

    }
    return self;
}
-(void)setUpWorld
{

    float screenWidthInMeters=screenSize.width/PTM_RATIO;
    float screenHeightInMeters=screenSize.height/PTM_RATIO;
    b2Vec2 lowerLeftCorner=b2Vec2(0, -screenHeightInMeters);
    b2Vec2 lowerRightCorner=b2Vec2(screenWidthInMeters,-screenHeightInMeters);
    b2Vec2 upperLeftCorner=b2Vec2(0,screenHeightInMeters);
    b2Vec2 upperRightCorner=b2Vec2(screenWidthInMeters,screenHeightInMeters);
    
    b2Vec2 gravity=b2Vec2(0.0,kGravity);
    bool allowBodiesToSleep=false;
    _world=new b2World(gravity, allowBodiesToSleep);
    b2BodyDef containerBodyDef;
    b2Body *containerBody=_world->CreateBody(&containerBodyDef);
    b2PolygonShape screenBoxShape;
    int density=0;
    //bottom
    screenBoxShape.SetAsEdge(lowerLeftCorner,lowerRightCorner);
    containerBody->CreateFixture(&screenBoxShape, density);
    //left
    screenBoxShape.SetAsEdge(lowerLeftCorner, upperLeftCorner);
    containerBody->CreateFixture(&screenBoxShape,density);
    //right
    screenBoxShape.SetAsEdge(lowerRightCorner, upperRightCorner);
    containerBody->CreateFixture(&screenBoxShape,density);
    //upper
    screenBoxShape.SetAsEdge(upperLeftCorner, upperRightCorner);
    containerBody->CreateFixture(&screenBoxShape, density);
}
-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    float deceleration=0.4f;
    float sensitivity=6.0f;
    // float sensitivityY=3.0f;
    float maxVelocity=100;
    float maxVelocityY=50;
    playerVelocity.x=playerVelocity.x*deceleration+acceleration.x*sensitivity;


    b2Vec2 gravity=b2Vec2(0.0, kGravity);
    _world->SetGravity(gravity);
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
        //[actor boundingBox]=[actor modifiedBoundingBox];
        
    } else {
        actor.flipX=YES;
       // [actor boundingBox]=[actor modifiedBoundingBox];
    }


}
-(void)update:(ccTime)delta
{

    // physics engine
    float timeStep=0.03f;
    float velocityIteration=4;
    float positionIteration=8;
    _world->Step(timeStep, velocityIteration, positionIteration);
    for (b2Body *body=_world->GetBodyList(); body!=nil; body=body->GetNext()) {
        
        GameObject *sprite=(GameObject *)body->GetUserData();
        if (sprite!=nil) {
            if ([sprite tag]==actorTag) {

                actorBody=body;
                // 풍선효과를 주는 조건문(중력을 무효화)
                if (balloonActivated==NO) {
                    //body->ApplyForce(b2Vec2(-playerVelocity.x*body->GetMass(), 0), body->GetWorldCenter());
                    //  b2Vec2 vec=body->GetWorldCenter();
                    //  CGPoint pos=[self toPixels:vec];
                    // CCLOG(@"actor is driven by the force origin : %f,%f",pos.x,pos.y);
                    
                } else if(balloonActivated==YES)
                {
                    body->ApplyForce(b2Vec2(0.0,kBalloonForce*body->GetMass()), body->GetWorldCenter());
                }
                //풍선효과 끝
                
                b2Vec2 vec= body->GetPosition();
                CGPoint pos=[self toPixels:vec];
                pos.x+=playerVelocity.x;
                vec=[self toMeters:pos];
                body->SetTransform(vec, 0);
            }
            else if([sprite tag]==stairTag)
            {
                CGRect actorRect=[actor boundingBox];
                CGRect stairRect=[sprite boundingBox];
                CGPoint actorPoint=actor.position;
                CGPoint stairPoint=sprite.position;
                Stair *stairObj=(Stair *)sprite;
                if (CGRectIntersectsRect(actorRect, stairRect) && actorPoint.y>stairPoint.y) 
                {
                    [stairObj changeState:kStateLanding body:body];
                } else{
                    if (speedUpItemActivated==NO) {
                        [stairObj changeState:kStateSpeedNormal body:body];
                    } else if(speedUpItemActivated==YES)
                    {
                        [stairObj changeState:kStateSpeedUp body:body];
                    }
                }
                
                if (speedUpItem.isActive==YES) 
                {
                    speedUpItem.position=CGPointMake(sprite.position.x, sprite.position.y+speedUpItem.contentSize.height*0.5);
                }
                if (speedUpItem.objectState==kStateEatUpItemWearOff) {
                    [self changeStairSpeed:kStateEatUpItemWearOff];
                }
                if (fish.isActive==YES) {
                    fish.position=CGPointMake(stair.position.x, stair.position.y+fish.contentSize.height*0.3);
                }
            } 
            sprite.position=[self toPixels:body->GetPosition()];
            float angle=body->GetAngle();
            sprite.rotation=CC_RADIANS_TO_DEGREES(angle)*-1;
        }
    }
    //physics engine end
    
    totalTime+=delta*stair.movingSpeed;
  
    int currentTime=(int)totalTime;
    if (score<currentTime) {
        score=currentTime;
        [scoreLabel setString:[NSString stringWithFormat:@"%i",score]];
    }
    
    CGPoint pos=actor.position;
    float playerImageHalf=actor.contentSize.width*0.5;
    if (pos.y<-playerImageHalf*3 || pos.y>ceiling.position.y-ceiling.contentSize.height*0.5) {

        pos=CGPointMake(screenSize.width*0.5, screenSize.height*0.6);
        [self gamePause];
    }
     
    if (balloonActivated==YES) {
        CCSprite *balloon=(CCSprite *)[self getChildByTag:balloonTag];
        balloon.position=CGPointMake(actor.position.x, actor.position.y+actor.contentSize.height*0.5);
        balloon.anchorPoint=CGPointMake(0.3, 0.5);//actor와 같은 앵커포인트를 갖게 함
        CGPoint posBall=balloon.position;
        if (posBall.y>ceilingPoint.y-ceilingSize.height*0.5) {
            balloonActivated=NO;
            balloon.visible=NO;
            actorBody->SetLinearVelocity(b2Vec2(0, 0));
            //actorBody->SetLinearDamping(50.0);
            [self schedule:@selector(resetBalloon) interval:10.0f];
        }
    }

    [self updateHealthBar];
    [wall updateState:delta gameObjects:nil];
    [self checkForCollision:delta];
}
-(void)checkForCollision:(ccTime)delta
{
    if (collisionSystem==defaultCollision) {} 
    else if(collisionSystem==rectCollision)
    {
        
        CCArray *charArray=[batch children];
        GameCharacter *landedStair=nil;
        for (GameCharacter *tempChar in charArray) {
            if ([tempChar tag]==actorTag) {
                //  [tempChar updateState:delta gameObjects:charArray];
                continue;
            }
            
            CGRect actorRect=[actor boundingBox];
            CGRect stairRect=[tempChar boundingBox];
           // CGPoint actorPoint=actor.position;
           // CGPoint stairPoint=tempChar.position;
            if (CGRectIntersectsRect(actorRect, stairRect)) 
            {
                [actor changeState:kStateLanding];
                
                landedStair=tempChar;
                //NSLog(@"landedStair character type is %d,%d",landedStair.gameObjectType,kTypeFlameStair);
                if (landedStair.gameObjectType==kTypeLongStair) {
                    [tempChar changeState:kStateLanding];
                }
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
            if (actor.objectState!=kStateLanding) {
                
                
                //NSLog(@"actor is falling");
            }
            else
            {
                // NSLog(@"actor is landed");
            }
            
            //  [tempChar updateState:delta gameObjects:charArray]; // stair를 올린다.
            
            
        }
        
        if (landedStair==nil) {
            [actor changeState:kStateFalling];
        }
        
        
        
        
    }
    else if(collisionSystem==contactCollision)
    {
        std::vector<b2Body *>toMove; 
        std::vector<MyContact>::iterator pos;
        for(pos = _contactListener->_contacts.begin(); 
            pos != _contactListener->_contacts.end(); ++pos) {
            MyContact contact = *pos;
            b2Body *bodyA = contact.fixtureA->GetBody();
            b2Body *bodyB = contact.fixtureB->GetBody();
            if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
                CCSprite *spriteA = (CCSprite *) bodyA->GetUserData();
                CCSprite *spriteB = (CCSprite *) bodyB->GetUserData();
                
                if (spriteA.tag == kTagSpeedUpItem && spriteB.tag == actorTag) {
                    CCLOG(@"destroy body A");
                    toMove.push_back(bodyA);
                } else if (spriteA.tag == actorTag && spriteB.tag == kTagSpeedUpItem) {
                    toMove.push_back(bodyB);
                } 
            }        
        }
        
        std::vector<b2Body *>::iterator pos2;
        for(pos2 = toMove.begin(); pos2 != toMove.end(); ++pos2) {
            b2Body *body = *pos2;
            SpeedUpItem *sprite;
            if (body->GetUserData() != NULL) {
                sprite = (SpeedUpItem *) body->GetUserData();
                sprite.position=CGPointMake(-100, -100);
            }
            body->SetTransform([self toMeters:sprite.position], 0);
        }
        
        if (toMove.size() > 0) {
            //[[SimpleAudioEngine sharedEngine] playEffect:@"hahaha.caf"];   
        }
    }
}
-(void)gamePause
{
    //[self resetStairs];

    int hiScore=[[dic objectForKey:@"hiScore"]intValue];
            //CCLOG(@"dictionary's retain count is %d in Gamepause method",[dic retainCount]);
  //  NSLog(@"object from dic is %d",[[dic objectForKey:@"hiScore"]intValue]);
    if (score>hiScore) {
        //NSLog(@" current score is %d, high score is %d",score,hiScore);
        hiScore=score;
        [dic setValue:[NSNumber numberWithInt:score] forKey:@"hiScore"];
       // NSLog(@"hiscore is %@",[dic objectForKey:@"hiScore"]);
    }
    [self changeStairSpeed:kStateSpeedNormal];
    [self pauseSchedulerAndActions];
    [self resetBalloon];
    [actor setHealth:kInitialHealth];
    //actor's box2d body reset
        for (b2Body *body=_world->GetBodyList(); body!=nil; body=body->GetNext())
        {
                   CCSprite *sprite=(CCSprite *)body->GetUserData();
            if ([sprite tag]==actorTag) {
                CGPoint pos=CGPointMake(screenSize.width*0.3, screenSize.height*0.8);
                float angle=body->GetAngle();
                sprite.rotation=CC_RADIANS_TO_DEGREES(angle)*-1;
                body->SetLinearVelocity(b2Vec2(0,0));

                body->SetTransform(b2Vec2([self toMeters:pos]), 0.0);
            }
        }
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
    item.anchorPoint=CGPointMake(0.5, 0.5);
    item.visible=YES;
    [self unschedule:@selector(resetBalloon)];
}
-(void)changeStairSpeed:(ObjectStates)state
{
    CCArray *charArray=[batch children];
    if (state==kStateEatUpItem) {
        for (GameObject *tempObj in charArray) {
            if ([tempObj tag]==actorTag || [tempObj tag]==kTagSpeedUpItem || [tempObj tag]==kTagFish) {
                continue;
            }
            speedUpItemActivated=YES;
            [tempObj changeState:kStateSpeedUp];
        }
    } else if(state==kStateEatUpItemWearOff)
    {
        for (GameObject *tempObj in charArray) {
            if ([tempObj tag]==actorTag || [tempObj tag]==kTagSpeedUpItem || [tempObj tag]==kTagFish){
                continue;
            }
            speedUpItemActivated=NO;
            [tempObj changeState:kStateSpeedNormal];
        }
    }
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

            [self spriteToBody:stair.position sprite:stair objectType:type];
            [stair release];
        }
 
      
    }  else if (type==kTypeActor)
    {
        actor=[Actor actor];
        actor.health=kInitialHealth;
        actor.delegate=self;
        [batch addChild:actor z:0 tag:actorTag];
        [self spriteToBody:actor.position sprite:actor objectType:type];
    } else if (type==kTypeBalloon)
    {
        CCSprite *itemBox=[CCSprite spriteWithSpriteFrameName:@"itemBox.png"];
        CGSize itemBoxSize=itemBox.contentSize;
        itemBox.position=CGPointMake(itemBoxSize.width*1.2, itemBoxSize.height);
        [self addChild:itemBox z:2 tag:itemBoxTag];
        
        CCSprite *item=[CCSprite spriteWithSpriteFrameName:@"balloon.png"];
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
-(b2Vec2)toMeters:(CGPoint)point
{
    return b2Vec2(point.x/PTM_RATIO, point.y/PTM_RATIO);
}
-(CGPoint)toPixels:(b2Vec2)vect
{
    return ccpMult(CGPointMake(vect.x, vect.y), PTM_RATIO);
}
-(void)spriteToBody:(CGPoint)pos sprite:(GameObject *)obj objectType:(GameObjectTypes)type
{
    b2BodyDef bodyDef;
    bodyDef.position=[self toMeters:pos];
    if (type==kTypeLongStair) 
    {
            bodyDef.type=b2_kinematicBody;
    }
    else if (type==kTypeActor )
    {
            bodyDef.type=b2_dynamicBody;
    }
    bodyDef.userData=(CCSprite *)obj;
    b2Body *body=_world->CreateBody(&bodyDef);
    b2PolygonShape polyShape;
    float tileWidthInMeters=obj.contentSize.width/PTM_RATIO/3;
    float tileHeightInMeters=obj.contentSize.height/PTM_RATIO/3;
    NSLog(@"tile in meters is (%f,%f)",tileWidthInMeters,tileHeightInMeters);

    polyShape.SetAsBox(tileWidthInMeters, tileHeightInMeters);

    b2FixtureDef bodyFixture;
    bodyFixture.shape=&polyShape;

    if (type==kTypeLongStair) 
    {
        bodyFixture.density=kStairDensity;
    bodyFixture.friction=0.5;
        CCLOG(@"stair's density is %f",bodyFixture.density);
    }
    else if (type==kTypeActor )
    {
            bodyFixture.density=kActorDensity;
            bodyFixture.friction=0.0;
        CCLOG(@"actor's density is %f",bodyFixture.density);
    }
   
    bodyFixture.restitution=kRestitution;
    body->CreateFixture(&bodyFixture);
    CCLOG(@"actor's mass when making is %f",body->GetMass());
}
-(void)updateHealthBar
{
    HealthBar *healthBar=(HealthBar *)[self getChildByTag:kHealthBar];
    float scale=actor.health/kInitialHealthFloat;
    [healthBar setScaleX:scale];
    //NSLog(@"healthbar's scale is %f, and health is %d",[healthBar scaleX],[actor health]);
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
            b2Vec2 actorVelocity=actorBody->GetLinearVelocity();
            b2Vec2 modifiedActorVelocity=b2Vec2(actorVelocity.x, actorVelocity.y*0.3);
            actorBody->SetLinearVelocity(modifiedActorVelocity);
            // actorBody->SetLinearVelocity();
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
-(void) draw
{
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
	_world->DrawDebugData();
    
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);	
}
-(void)dealloc
{
    delete _debugDraw;
    delete _contactListener;
    delete _world;
    [dic release];
    [speedUpItem release];
    [ceiling release];
    [wall release];
    [super dealloc];
}
@end
