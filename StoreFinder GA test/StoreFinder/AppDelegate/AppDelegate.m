//
//  AppDelegate.m
//  StoreFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import "AppDelegate.h"
#import "ECSlidingViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <FacebookSDK/FacebookSDK.h>
#import "GAI.h"

@interface AppDelegate () <FHSTwitterEngineAccessTokenDelegate, CLLocationManagerDelegate> {
    
    CLLocationManager* _myLocationManager;
}

@property (nonatomic, strong) ECSlidingViewController *slidingViewController;

@end

@implementation AppDelegate

@synthesize sideViewController;
@synthesize contentViewController;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize session;
@synthesize myLocation;
@synthesize transitions;
@synthesize locationDelegate = _locationDelegate;

+(AppDelegate *)instance {
    
    
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-58498322-1"];
    
    // Override point for customization after application launch.
    [Fabric with:@[CrashlyticsKit]];
    
    // Override point for customization after application launch.
    [MGUIAppearance enhanceNavBarAppearance:NAV_BAR_BG];
    
    [MGUIAppearance enhanceBarButtonAppearance:WHITE_TINT_COLOR];
    
    [MGUIAppearance enhanceToolbarAppearance:NAV_BAR_BG];
    
    if (DOES_SUPPORT_IOS7) {
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UINavigationController* navController = [storyboard instantiateViewControllerWithIdentifier:@"storyboardNavigation"];
    
    sideViewController = [storyboard instantiateViewControllerWithIdentifier:@"storyboardSideView"];
    
    self.slidingViewController = [ECSlidingViewController slidingWithTopViewController:navController];
    self.slidingViewController.underLeftViewController  = sideViewController;
    self.slidingViewController.underRightViewController = nil;
    
    self.slidingViewController.anchorRightPeekAmount  = ANCHOR_LEFT_PEEK; //44.0
    self.slidingViewController.anchorLeftRevealAmount = ANCHOR_RIGHT_PEEK; //276.0
    
    self.window.rootViewController = self.slidingViewController;
    [self.window makeKeyAndVisible];
    
    [[FHSTwitterEngine sharedEngine] permanentlySetConsumerKey:TWITTER_CONSUMER_KEY
                                                     andSecret:TWITTER_CONSUMER_SECRET];
    
    [[FHSTwitterEngine sharedEngine]setDelegate:self];
    
    [MGFileManager deleteAllFilesAtDocumentsFolderWithExt:@"png"];
    
    [self setTransitionIndex:[self getTransitionIndex]];
    
    
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
    
    [FBAppEvents activateApp];
    
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [self.session close];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"db_data.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - TWITTER

- (NSString *)loadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"TWITTER_ACCESS_TOKEN"];
}

- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"TWITTER_ACCESS_TOKEN"];
}

- (METransitions *)transitions {
    if (transitions) return transitions;
    
    transitions = [[METransitions alloc] init];
    
    return transitions;
}


-(int)getTransitionIndex {
    return [[[NSUserDefaults standardUserDefaults]objectForKey:@"TRANSITION_INDEX"] intValue];
}

-(void)setTransitionIndex:(int)index {
    
    NSDictionary *transitionData = self.transitions.all[index];
    id<ECSlidingViewControllerDelegate> transition = transitionData[@"transition"];
    
    if (transition == (id)[NSNull null]) {
        self.slidingViewController.delegate = nil;
    } else {
        self.slidingViewController.delegate = transition;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d", index] forKey:@"TRANSITION_INDEX"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - FIND USER LOCATION

-(void)findMyCurrentLocation {
    
    if(_myLocationManager == nil) {
        _myLocationManager = [[CLLocationManager alloc] init];
        _myLocationManager.delegate = self;
    }
    
    if(IS_OS_8_OR_LATER) {
        [_myLocationManager requestWhenInUseAuthorization];
        [_myLocationManager requestAlwaysAuthorization];
    }
    
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusAuthorized ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse ||
        authorizationStatus == kCLAuthorizationStatusNotDetermined) {
        
        [_myLocationManager startUpdatingLocation];
        
    }
    
    if( [CLLocationManager locationServicesEnabled] ) {
        NSLog(@"Location Services Enabled....");
    }
    else {
        [MGUtilities showAlertTitle:LOCALIZED(@"Location Service Error")
                            message:LOCALIZED(@"Location Service not enabled.")];
        
        if([self respondsToSelector:@selector(appDelegate:sensorError:)])
            [self.locationDelegate appDelegate:self sensorError:_myLocationManager];
    }
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    myLocation = newLocation;
    [self.locationDelegate appDelegate:self
                       locationManager:manager
                   didUpdateToLocation:newLocation
                          fromLocation:oldLocation];
}


- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error {
    
    [self.locationDelegate appDelegate:self
                       locationManager:manager
                      didFailWithError:error];
}


@end
