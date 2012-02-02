//
//  GameObject.m
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 15..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import "GameObject.h"


@implementation GameObject
@synthesize screenSize,gameObjectType,isActive,meetBoundaries,objectState;
-(id)init
{
    if (self=[super init]) 
    {
        screenSize=[[CCDirector sharedDirector]winSize];
        isActive=TRUE;
    }
    return self;
}
-(void)updateState:(ccTime)dt gameObjects:(CCArray *)obj
{
    //NSLog(@"override this method");
}

-(void)changeState:(ObjectStates)state
{
       // NSLog(@"override this method");
    [self setObjectState:state];
}
-(CGRect)modifiedBoundingBox
{

    NSLog(@"override this method");
    return [self boundingBox];
}
-(CCAnimation *)loadPlistForAnimationWithName:(NSString *)animationName className:(NSString *)className
{
    NSLog(@"loading plist for animation ....");
    CCAnimation *animationToReturn;
    NSString *documentPath;
    NSString *fullFileName;
    fullFileName=[NSString stringWithFormat:@"%@.plist",className];
    documentPath=[self applicationDocumentsDirectory];
    NSString *fullFileNameWithPath=[fullFileName stringByAppendingPathComponent:documentPath];
    if (![[NSFileManager defaultManager]fileExistsAtPath:fullFileNameWithPath]) {
        fullFileNameWithPath=[[NSBundle mainBundle]pathForResource:className ofType:@"plist"];
    }
    NSLog(@"document path is %@",fullFileNameWithPath);
    NSDictionary *animDic=[NSDictionary dictionaryWithContentsOfFile:fullFileNameWithPath];
    if (animDic==nil) {
        CCLOG(@"Error reading %@.plist file",className);
        return  nil;
    }
    NSDictionary *animSettings=[animDic objectForKey:animationName];
    if (animSettings==nil) {
        CCLOG(@"animation with name %@ can't be found",animationName);
        return  nil;
    }
    animationToReturn=[CCAnimation animation];
    float animationDelay=[[animSettings objectForKey:@"delay"]floatValue];
    [animationToReturn setDelay:animationDelay];
    NSString *animationNamePrefix=[animSettings objectForKey:@"filenamePrefix"];
    NSString *animationFrames=[animSettings objectForKey:@"animationFrames"];
    CCLOG(@"animationframes is %@",animationFrames);
    NSArray *animFramesArray=[animationFrames componentsSeparatedByString:@","];
    NSLog(@"animFramesArray has %d object",[animFramesArray count]);
    for (NSString *frameNumber in animFramesArray) {
        NSString *spriteFrameName=[NSString stringWithFormat:@"%@%@.png",animationNamePrefix,frameNumber];
        [animationToReturn addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteFrameName]]; 
    }
    
    return animationToReturn;
}
#pragma mark -
#pragma mark Application's Documents directory
                  
    /**
     Returns the path to the application's Documents directory.
     */
                  - (NSString *)applicationDocumentsDirectory {
                      return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                  }

-(void)dealloc
{
    [super dealloc];
}
@end
