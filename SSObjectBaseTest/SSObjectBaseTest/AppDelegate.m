//
//  AppDelegate.m
//  SSObjectBaseTest
//
//  Created by Steven on 13-12-17.
//  Copyright (c) 2013年 Steven. All rights reserved.
//

#import "AppDelegate.h"
#import "PersonObject.h"
#import "GroupObject.h"
#import "ClassesObject.h"

#define vPersonCount            3
#define vGroupCount             3

/*对象序列化成文件时保存的路径*/
#define vObjectSavePath         ([NSHomeDirectory() stringByAppendingPathComponent:@"ClassesObject.plist"])

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    /*班级对象、组对象、人对象，都继承自SSObjectBase*/
    ClassesObject * classes = [ClassesObject create];
    for (int i = 0; i < vGroupCount; i++) {
        
        GroupObject * group = [GroupObject create];
        group.count = i;
        group.groupName = [NSString stringWithFormat:@"Group %d", i];
        
        for (int j = 0; j < vPersonCount; j++) {
 
            PersonObject * person = [PersonObject create];
            person.count = j;
            person.name = [NSString stringWithFormat:@"Group %d: Person %d", i, j];
            NSLog(@"%@", person.name);
            
            [group.personList addObject:person];
        }
        
        [classes.groupList addObject:group];
    }
    
    /*序列化ClassesObject*/
    [classes saveToFile:vObjectSavePath];
    classes = nil;
    
    /*反序列化ClassesObject，并输出结果*/
    ClassesObject * loadClasses = [ClassesObject loadFromFile:vObjectSavePath];
    NSLog(@"反序列化结果：");
    if (loadClasses && [loadClasses groupList] && [[loadClasses groupList] isKindOfClass:[NSMutableArray class]]) {
        for (GroupObject * g in [loadClasses groupList]) {
            if (g && [g isKindOfClass:[GroupObject class]]) {
                for (PersonObject * p in [g personList]) {
                    NSLog(@"%@", p.name);
                }
            }
        }
    }
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
