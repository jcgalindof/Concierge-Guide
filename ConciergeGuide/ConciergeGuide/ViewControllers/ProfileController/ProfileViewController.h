//
//  ProfileViewController.h
//  StoreFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGProfileView.h"

@interface ProfileViewController : UIViewController <UITextFieldDelegate> {
    
    MGProfileView* _profileView;
}

@property (nonatomic, retain) IBOutlet MGRawScrollView* scrollViewMain;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* barButtonCancel;

-(IBAction)didClickButtonCancel:(id)sender;

@end
