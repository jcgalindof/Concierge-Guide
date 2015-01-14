//
//  SearchResultViewController.h
//  StoreFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultViewController : UIViewController

@property (nonatomic, retain) IBOutlet MGListView* listViewMain;
@property (nonatomic, retain) NSMutableArray* arrayResults;

@end
