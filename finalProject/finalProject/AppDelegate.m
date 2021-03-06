//
//  AppDelegate.m
//  finalProject
//
//  Created by Daniel Distant on 10/10/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "Learner.h"
#import "Skill.h"
#import "JournalEntry.h"
#import "ColorData.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Parse setApplicationId:@"ldTa8ST6XU38mX1p8d3nRO5fAzQBYhnRP4jrShqp" clientKey:@"O7QfhjkshaasBqsybWyj4sliMeVMTbHckTaqPSm1"];
    
    [Learner registerSubclass];
    [JournalEntry registerSubclass];
    [Skill registerSubclass];
    
    
    NSLog(@"LearnerSkill: %@", [[NSUserDefaults standardUserDefaults] objectForKey:LearnerSkillKey]);
    
    //Check if there is a Learner skillName saved in NSUserDefaults
    
    //if not, RootViewController of the Storyboard is the WelcomeViewController
    
    //otherwise make the MainTabBarController the RootViewController of the storyboard
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:LearnerSkillKey]) {
        
        UIStoryboard *storyboard = self.window.rootViewController.storyboard;
        
        UIViewController *welcomeViewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
        
        self.window.rootViewController = welcomeViewController;
        
        [self.window makeKeyAndVisible];
        
    }else {
        
        UIStoryboard *storyboard = self.window.rootViewController.storyboard;
        
        UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
        
        self.window.rootViewController = tabBarController;
        
        [self.window makeKeyAndVisible];
        
    }

    //setting the tint color of the tab bar
    
    [[UITabBar appearance] setTintColor:[ColorData sharedModel].oceanTeal];
 
     
    //Just checking to see if we're hooked up with Parse.
    
//    Learner *parseTestLearner = [[Learner alloc] init];
//    parseTestLearner.learnerName = @"Carla";
//    
//    [parseTestLearner saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            NSLog(@"Object uploaded!");
//        } else {
//            NSLog(@"Error: %@", [error localizedDescription]);
//        }
//    }];
    
//    Skill *testSkill = [[Skill alloc] init];
//    testSkill.skillName = @"Jolene";
//    
//    [testSkill saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        if (succeeded) {
//            NSLog(@"Object uploaded!");
//        }else{
//            NSLog(@"Error: %@", [error localizedDescription]);
//        }
//    }];
//    
//    JournalEntry *testEntry = [[JournalEntry alloc] init];
//    testEntry.entryTitle = @"Cupcakes";
//    
//    [testEntry saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        if (succeeded) {
//            NSLog(@"Object uploaded!");
//        }else {
//            NSLog(@"Error: %@", [error localizedDescription]);
//        }
//    }];

    //Just more testing
//    [Skill fetchAll:^(NSArray *results, NSError *error) {
//        Skill *skill = results[0];
//        NSLog(@"%@", skill.skillName);
//    }];
    
    
    
    //Checking the font names
    
//    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
//    NSArray *fontNames;
//    NSInteger indFamily, indFont;
//    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
//    {
//        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
//        fontNames = [[NSArray alloc] initWithArray:
//                     [UIFont fontNamesForFamilyName:
//                      [familyNames objectAtIndex:indFamily]]];
//        for (indFont=0; indFont<[fontNames count]; ++indFont)
//        {
//            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
//        }
//    }



    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "nyc.c4q.finalProject" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"finalProject" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"finalProject.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
