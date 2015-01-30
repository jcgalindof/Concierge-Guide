//
//  AboutUsViewController.h
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsViewController : UIViewController <MFMailComposeViewControllerDelegate> {
    
    MGRawView* _aboutView;
}

@property (nonatomic, retain) IBOutlet MGRawScrollView* scrollViewMain;
@end
