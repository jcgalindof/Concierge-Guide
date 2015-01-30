//
//  AppDelegate.h
//  StoreFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"
#import "SideViewController.h"
#import "ReviewViewController.h"

@class AppDelegate;

@protocol LocationDelegate <NSObject>

-(void) appDelegate:(AppDelegate*)appDelegate locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
       fromLocation:(CLLocation *)oldLocation;

-(void) appDelegate:(AppDelegate*)appDelegate locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error;

@optional
-(void) appDelegate:(AppDelegate*)appDelegate sensorError: (CLLocationManager *)manager;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    id <LocationDelegate> _locationDelegate;
}

@property (strong, retain) id <LocationDelegate> locationDelegate;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) ContentViewController* contentViewController;
@property (nonatomic, strong) SideViewController* sideViewController;

+(AppDelegate*) instance;

@property (nonatomic, strong) CLLocation* myLocation;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void) saveContext;

@property (strong, nonatomic) FBSession *session;

@property (nonatomic, strong) METransitions *transitions;

-(void)setTransitionIndex:(int)index;
-(int)getTransitionIndex;

-(void)findMyCurrentLocation;

@end
