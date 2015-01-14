//
//  SideViewController.h
//  StoreFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

-(IBAction)didClickButtonMenu:(id)sender;
@property(nonatomic, retain) IBOutlet UITableView* tableViewSide;
@property(nonatomic, retain) IBOutlet UIButton* buttonMenuClose;

-(void)updateUI;

@end
