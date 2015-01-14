//
//  DetailViewController.h
//  StoreFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (nonatomic, retain) IBOutlet MGListView* tableViewMain;
@property (nonatomic, retain) Store* store;

@end
