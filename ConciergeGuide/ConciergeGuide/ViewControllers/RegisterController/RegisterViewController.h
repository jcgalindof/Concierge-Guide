//
//  RegisterViewController.h
//  StoreFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGRegisterView.h"

@interface RegisterViewController : UIViewController <UITextFieldDelegate> {
    
    MGRegisterView* _registerView;
}

@property (nonatomic, retain) IBOutlet MGRawScrollView* scrollViewRegister;

@property (nonatomic, retain) IBOutlet UIBarButtonItem* barButtonCancel;

-(IBAction)didClickCancelLogin:(id)sender;

@end
