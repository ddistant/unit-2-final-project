//
//  AppDelegate.h
//  finalProject
//
//  Created by Daniel Distant on 10/10/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

//COLOR SCHEME
//creamsicleOrange = FF8552  rgb(255,133,82)
//
//icicleGray = E6E6E6  rgb(230,230,230)
//
//pavementGray = 39393A  rgb(57,57,58)
//
//oceanTeal = 297373  rgb(41,115,115)
//
//chartreuseYellow = E9D758  rgb(233,215,88)

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

