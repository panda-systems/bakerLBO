//
//  AppDelegate.m
//  Baker_MA_iOS
//
//  Created by Oleg Bolshakov on 6/26/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import "AppDelegate.h"
#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>
#import "WebViewTool.h"
#import "BMHomeViewController.h"
#import "BMIntroductionViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setWindowRootViewController];
    
    // Navigation Bar appearance
    //[UINavigationBar appearance].backgroundColor = [UIColor whiteColor];
    [UINavigationBar appearance].barTintColor = [UIColor whiteColor];
    [UINavigationBar appearance].tintColor = [UIColor colorWithRed:230.0f/255.0f green:183.0f/255.0f blue:19.0f/255.0f alpha:1.0];
    [UINavigationBar appearance].shadowImage = [[UIImage alloc] init];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];// = [[UIImage alloc] init];
    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:95.0f/255.0f green:95.0f/255.0f blue:95.0f/255.0f alpha:1.0],NSFontAttributeName : [UIFont fontWithName:@"Roboto-Regular" size:20]};
    // [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"backArrow"];
    
    //[[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"backArrow"]
      //                                                forState:UIControlStateNormal
        //                                            barMetrics:UIBarMetricsDefault];
    
   // UINavigationBar.appearance().backIndicatorImage = UIImage(named: "backArrow")
   // UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrow")
//    UINavigationBar.appearance().barStyle = .Black
//    UINavigationBar.appearance().barTintColor = UIColor(red: 42.0/255.0, green: 49.0/255.0, blue: 57.0/255.0, alpha: 1)
   // [UINavigationBar appearance].tintColor = [UIColor colorWithRed:230.0/255.0 green:183.0/255.0 blue:19.0/255.0 alpha:1];
//    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont(name: "HelveticaNeue", size: 17)!];
//    UINavigationBar.appearance().translucent = false
//    UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
//    UINavigationBar.appearance().shadowImage = UIImage()
//    
    
 
    
    NSURL *baseURL = [NSURL URLWithString:@"http://67.205.60.227:81"];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    
    [objectManager.HTTPClient setAuthorizationHeaderWithUsername:@"root" password:@"729082"];
    
    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    // Initialize managed object store
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
    
    
    
    // Complete Core Data stack initialization
    [managedObjectStore createPersistentStoreCoordinator];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"BakerDB.sqlite"];
    NSString *seedPath = [[NSBundle mainBundle] pathForResource:@"RKSeedDatabase" ofType:@"sqlite"];
    NSError *error;
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:seedPath withConfiguration:nil options:nil error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    
    // Create the managed object contexts
    [managedObjectStore createManagedObjectContexts];
    
    // Configure a managed object cache to ensure we do not create duplicate objects
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
    
    
    // Init Data Mapping
    RKEntityMapping *initDataMapping = [RKEntityMapping mappingForEntityForName:@"BMInitData" inManagedObjectStore:managedObjectStore];
    initDataMapping.identificationAttributes = @[ @"databaseId" ];
    
    [initDataMapping
     addAttributeMappingsFromDictionary:
     @{
       @"timeStamp" : @"timestamp",
       @"id" : @"databaseId",
       @"lastUpdate" : @"lastUpdate",
       @"dataChanged" : @"dataChanged"
       }
     ];
    
    // Settings Mapping
    RKEntityMapping *settingsMapping = [RKEntityMapping mappingForEntityForName:@"BMSettings" inManagedObjectStore:managedObjectStore];
    settingsMapping.identificationAttributes = @[ @"settingsId" ];
    [settingsMapping addAttributeMappingsFromDictionary:@{@"introduction" : @"introduction",
                                                          @"id" : @"settingsId",
                                                          @"css" : @"css",
                                                          @"info" : @"info",
                                                          @"status" : @"status",
                                                          @"database" : @"databaseName"}];
    
    [initDataMapping addPropertyMapping:
     [RKRelationshipMapping relationshipMappingFromKeyPath:@"settings"
                                                 toKeyPath:@"settings"
                                               withMapping:settingsMapping]
     ];
    
    
    // Countries Mapping
    RKEntityMapping *countryMapping = [RKEntityMapping mappingForEntityForName:@"BMCountry" inManagedObjectStore:managedObjectStore];
    countryMapping.identificationAttributes = @[ @"countryId" ];
    [countryMapping addAttributeMappingsFromDictionary:@{@"name" : @"name",
                                                         @"id" : @"countryId",
                                                         @"status" : @"status"}];
    
    [initDataMapping addPropertyMapping:
     [RKRelationshipMapping relationshipMappingFromKeyPath:@"countries"
                                                 toKeyPath:@"countries"
                                               withMapping:countryMapping]
     ];
    
    
    // Contacts Mapping
    RKEntityMapping *contactMapping = [RKEntityMapping mappingForEntityForName:@"BMContact" inManagedObjectStore:managedObjectStore];
    contactMapping.identificationAttributes = @[ @"contactId" ];
    [contactMapping addAttributeMappingsFromDictionary:@{@"first_name" : @"firstName",
                                                         @"last_name" : @"lastName",
                                                         @"phone" : @"phoneNumber",
                                                         @"id" : @"contactId",
                                                         @"email" : @"email",
                                                         @"get_icon" : @"avatar" }];
    
    [countryMapping addPropertyMapping:
     [RKRelationshipMapping relationshipMappingFromKeyPath:@"contacts"
                                                 toKeyPath:@"contacts"
                                               withMapping:contactMapping]
     ];
    
    
    // Topics Mapping
    RKEntityMapping *topicMapping = [RKEntityMapping mappingForEntityForName:@"BMTopic" inManagedObjectStore:managedObjectStore];
    topicMapping.identificationAttributes = @[ @"topicId" ];
    [topicMapping addAttributeMappingsFromDictionary:@{@"html" : @"htmlData",
                                                       @"title" : @"title",
                                                       @"id" : @"topicId",
                                                       @"status" : @"status" }];
    
    [countryMapping addPropertyMapping:
    [RKRelationshipMapping relationshipMappingFromKeyPath:@"topics"
                                                 toKeyPath:@"topics"
                                               withMapping:topicMapping]
    ];
    
    // SubTopics Mapping
    RKEntityMapping *subTopicMapping = [RKEntityMapping mappingForEntityForName:@"BMSubTopic" inManagedObjectStore:managedObjectStore];
    subTopicMapping.identificationAttributes = @[ @"subTopicId" ];
    [subTopicMapping addAttributeMappingsFromDictionary:@{@"html" : @"htmlData",
                                                          @"title" : @"title",
                                                          @"id" : @"subTopicId",
                                                          @"status" : @"status" }];
    
    [topicMapping addPropertyMapping:
     [RKRelationshipMapping relationshipMappingFromKeyPath:@"children"
                                                 toKeyPath:@"subtopics"
                                               withMapping:subTopicMapping]
     ];
    
    // Subjects Mapping
    RKEntityMapping *subjectMapping = [RKEntityMapping mappingForEntityForName:@"BMSubject" inManagedObjectStore:managedObjectStore];
    subjectMapping.identificationAttributes = @[ @"subjectId" ];
    [subjectMapping addAttributeMappingsFromDictionary:@{@"html" : @"htmlData",
                                                         @"title" : @"title",
                                                         @"id" : @"subjectId",
                                                         @"status" : @"status" }];
    
    [subTopicMapping addPropertyMapping:
     [RKRelationshipMapping relationshipMappingFromKeyPath:@"children"
                                                 toKeyPath:@"subjects"
                                               withMapping:subjectMapping]
     ];



    
    // Setting Init Descriptor
    RKResponseDescriptor *initDataResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:initDataMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/api/init/data/"
                                                keyPath:nil
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
     ];
    
    [objectManager addResponseDescriptor:initDataResponseDescriptor];
    
    RKResponseDescriptor *refreshDataResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:initDataMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/api/refresh/data/"
                                                keyPath:nil
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
     ];
    
    [objectManager addResponseDescriptor:initDataResponseDescriptor];
    [objectManager addResponseDescriptor:refreshDataResponseDescriptor];
    
    
    // Enable Loader
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    if ([[UIApplication sharedApplication]
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *userNotificationSettings = [UIUserNotificationSettings
                                        settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound)
                                        categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:userNotificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType remoteNotificationType = (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |
                                      UIRemoteNotificationTypeSound);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:remoteNotificationType];
    }
    
    NSString *checkLoaded = [[NSUserDefaults standardUserDefaults] valueForKey:@"initialDataLoaded"];
    if (![checkLoaded isEqualToString:@"YES"]) {
        sleep(3.0);
    }
    return YES;
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *date = [formatter stringFromDate:[NSDate date]];
    
    NSString *requestPath = [NSString stringWithFormat:@"%@%@", @"/api/refresh/data/?date=",date];
    [[RKObjectManager sharedManager]
     getObjectsAtPath:requestPath
     parameters:nil
     success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
         
         
         
         
         NSArray* notificationTypes = @[@"none"];
         if (notificationTypes) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"BMDataUpdated" object:nil userInfo:@{@"types": notificationTypes}];
         }
         [[WebViewTool sharedWebViewTool] updateCSSString];
         //articles have been saved in core data by now
         //[self fetchArticlesFromContext];
         //[[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"initDataLoaded"]; 
         //[[NSUserDefaults standardUserDefaults] synchronize];
         
     }
     failure: ^(RKObjectRequestOperation *operation, NSError *error) {
         RKLogError(@"Load failed with error: %@", error);
         //[[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Network error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
     }
     ];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString* urlString = [NSString stringWithFormat:@"http://67.205.60.227:81/api/add/device/ios/"];
    NSDictionary* params;
    NSString *devToken = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    params = @{@"device" : devToken};
    
    [[RKObjectManager sharedManager].HTTPClient getPath:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
     }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
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
//
//#pragma mark - Core Data stack
//
//@synthesize managedObjectContext = _managedObjectContext;
//@synthesize managedObjectModel = _managedObjectModel;
//@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
//
//- (NSURL *)applicationDocumentsDirectory {
//    // The directory the application uses to store the Core Data store file. This code uses a directory named "Panda.Baker_MA_iOS" in the application's documents directory.
//    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//}
//
//- (NSManagedObjectModel *)managedObjectModel {
//    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
//    if (_managedObjectModel != nil) {
//        return _managedObjectModel;
//    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Baker_MA_iOS" withExtension:@"momd"];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    return _managedObjectModel;
//}
//
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
//    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
//    if (_persistentStoreCoordinator != nil) {
//        return _persistentStoreCoordinator;
//    }
//    
//    // Create the coordinator and store
//    
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Baker_MA_iOS.sqlite"];
//    NSError *error = nil;
//    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//        // Report any error we got.
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
//        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
//        dict[NSUnderlyingErrorKey] = error;
//        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
//        // Replace this with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    
//    return _persistentStoreCoordinator;
//}
//
//
//- (NSManagedObjectContext *)managedObjectContext {
//    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
//    if (_managedObjectContext != nil) {
//        return _managedObjectContext;
//    }
//    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (!coordinator) {
//        return nil;
//    }
//    _managedObjectContext = [[NSManagedObjectContext alloc] init];
//    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
//    return _managedObjectContext;
//}
//
//#pragma mark - Core Data Saving support
//
//- (void)saveContext {
//    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil) {
//        NSError *error = nil;
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }
//}

#pragma mark - Methods

- (void)setWindowRootViewController {
    //for iPad in landscape we will start with split view. For other cases - with ususal view
    
    UIUserInterfaceIdiom deviceType = [[UIDevice currentDevice] userInterfaceIdiom];
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (orientation == UIDeviceOrientationUnknown) {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        if (CGRectGetWidth(screenBounds) > CGRectGetHeight(screenBounds)) {
            orientation = UIDeviceOrientationLandscapeLeft;
        }
    }
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (deviceType == UIUserInterfaceIdiomPad && (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight)) {
        UISplitViewController *splitVC = [[UISplitViewController alloc] init];
        
        BMHomeViewController *masterVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"BMHomeViewController"];
        UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:masterVC];
        splitVC.delegate = masterVC;
        
        BMIntroductionViewController *detailVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"BMIntroductionViewController"];
        UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:detailVC];
        
        splitVC.viewControllers = [NSArray arrayWithObjects:masterNav, detailNav, nil];

        self.window.rootViewController = splitVC;
    } else {
        BMHomeViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"BMHomeViewController"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nav;
    }
    
    [self.window makeKeyAndVisible];
}


@end
