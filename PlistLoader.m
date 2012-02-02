//
//  PlistLoader.m
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 23..
//  Copyright 2011년 SK M&S. All rights reserved.
//

#import "PlistLoader.h"

@implementation PlistLoader

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
-(NSMutableDictionary *)PlistLoadFromFileName:(NSString *)fileName
{
    NSString *fileNameWithExtension=[NSString stringWithFormat:@"%@.plist",fileName];
    NSString *documentPath=[self applicationDocumentsDirectory];
    NSString *fileNameWithDirectory=[documentPath stringByAppendingPathComponent:fileNameWithExtension];
    NSLog(@"Score.plist exists at %@",fileNameWithDirectory);
    if (![[NSFileManager defaultManager]fileExistsAtPath:fileNameWithDirectory]) {
        fileNameWithDirectory=[[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    }
    dic=[NSMutableDictionary dictionaryWithContentsOfFile:fileNameWithDirectory];
    if (dic==nil) {
        NSLog(@"Error reading %@.plist file",fileName);
        return  nil;
    }
    return dic;
}
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
@end
